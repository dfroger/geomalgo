import numpy as np

from .constant cimport *

ctypedef (bint, int) bint_int

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

    def index_of(InternEdges self, int V0, int V1):
        """
        Retrieve index for intern edge(V0, V1)
        """
        cdef:
            bint found
            int location
            int I, E
            int V0_, V1_

        found, E = self.edge_map.search_edge_idx(V0, V1)

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
