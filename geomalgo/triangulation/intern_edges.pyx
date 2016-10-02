import numpy as np

from .constant cimport *


cdef class InternEdges:
    """
    Intern edges vertices (V0, V1) are stored such as V0 < V1, and
    sorted on increasing V0.

    (V0, V1, T0) is counterclockwise, and (V0, V1, T1) is clockwise.
    """

    def __init__(self, size):
        self.size = size
        self.vertices = np.empty((size, 2), dtype='int32')
        self.triangles = np.empty((size, 2), dtype='int32')

    def reorder(InternEdges self, int[:,:] vertices):
        """

        Updates:
        --------
            - edge_map.idx
            - triangle
            - vertices
        """
        cdef:
            bint[:] check_consistancy
            int V0_NEW, V1_NEW, V0_OLD, V1_OLD
            int INEW, IOLD
            int[:,:] triangles_new
            int[:] idx_new
            int E, Einf
            bint found

        if vertices.shape[0] != self.size:
            raise ValueError('Expected {} interfaces, got {}'
                             .format(vertices.shape[0], self.size))

        if vertices.shape[1] != 2:
            raise ValueError('Each interfaces must have 2 vertices, got {}'
                             .format(vertices.shape[1]))

        check_consistancy = np.zeros(self.size, dtype='int32')
        triangles_new = np.empty_like(self.triangles)
        idx_new = np.copy(self.edge_map.idx) # keep BoundaryEdges indices

        for INEW in range(self.size):
            V0_NEW = vertices[INEW, 0]
            V1_NEW = vertices[INEW, 1]

            # Update V0V1 such as V1 > V0
            E = self.edge_map.search_edge_idx(V0_NEW, V1_NEW, &found)
            if not found or self.edge_map.location[E] != INTERN_EDGE:
                raise ValueError(
                    'Edge {} with vertices ({},{}) such as V1>V0 not found'
                    .format(INEW, V0_NEW, V1_NEW))
            IOLD = self.edge_map.idx[E]

            # Update V0V1 such as Vl < V0
            Einf = self.edge_map.search_edge_idx_inf(V0_NEW, V1_NEW, &found)
            if not found or self.edge_map.location[Einf] != INTERN_EDGE:
                raise ValueError(
                    'Edge {} with vertices ({},{}) such as V1<V0 not found'
                    .format(INEW, V0_NEW, V1_NEW))
            assert self.edge_map.idx[Einf] == IOLD

            check_consistancy[IOLD] += 1
            if check_consistancy[IOLD] > 1:
                raise ValueError("Edge ({}, {}) is duplicated"
                                 .format(V0_NEW, V1_NEW))

            V0_OLD = self.vertices[IOLD, 0]
            V1_OLD = self.vertices[IOLD, 1]

            if V0_NEW == V0_OLD and V1_NEW == V1_OLD:
                triangles_new[INEW, 0] = self.triangles[IOLD, 0]
                triangles_new[INEW, 1] = self.triangles[IOLD, 1]

            elif V0_NEW == V1_OLD and V1_NEW == V0_OLD:
                triangles_new[INEW, 0] = self.triangles[IOLD, 1]
                triangles_new[INEW, 1] = self.triangles[IOLD, 0]

            else:
                raise RuntimeError(
                    "Expected vertices ({}, {}), but got vertices ({}, {})"
                    .format(V0_NEW, V1_NEW, V0_OLD, V1_OLD))

            idx_new[E] = INEW
            idx_new[Einf] = INEW

        self.edge_map.idx[:] = idx_new
        self.triangles[:] = triangles_new
        self.vertices[:,:] = vertices

    def index_of(InternEdges self, int V0, int V1):
        """
        Retrieve index for intern edge(V0, V1)
        """
        cdef:
            bint found
            int location
            int I, E
            int V0_, V1_

        E = self.edge_map.search_edge_idx(V0, V1, &found)

        if not found:
            raise KeyError("No such intern edge ({}, {})".format(V0, V1))

        location = self.edge_map.location[E]

        if location == INTERN_EDGE:
            I = self.edge_map.idx[E]
            V0_ = self.vertices[I, 0]
            V1_ = self.vertices[I, 1]
            if not ((V0==V0_ and V1==V1_) or (V0==V1_ and V1==V0_)):
                raise RuntimeError(
                    "Expected vertices ({}, {}), but got vertices ({}, {})"
                    .format(V0, V1, V0_, V1_))
            return I

        elif location == BOUNDARY_EDGE:
            raise KeyError("({}, {}) is a boundary edge".format(V0, V1))

        else:
            RuntimeError("Unexpected edge location: {}".format(location))

    def __getitem__(self, V0V1):
        """
        Retrive triangles for intern edge (V0, V1).
        """
        cdef:
            int I, V0, V1
        V0, V1 = V0V1
        I = self.index_of(V0, V1)
        return np.asarray(self.triangles[I], dtype='int32')
