import numpy as np

from ..base2d.point2d cimport (
    CPoint2D, c_point2d_distance
)

from ..base2d.vector2d cimport (
    CVector2D, compute_normal2d, compute_norm2d
)

from .constant cimport *


cdef class BoundaryEdges:
    """
    Boundary edges are stored such that (V0, V1, T) is counterclockwise
    """

    def __init__(self, size):
        self.size = size
        self.vertices = np.empty((size, 2), dtype='int32')
        self.triangle = np.empty(size, dtype='int32')
        self.next_boundary_edge = np.empty(size, dtype='int32')

    def reorder(BoundaryEdges self, int[:,:] vertices):
        cdef:
            bint[:] check_consistancy
            int V0_NEW, V1_NEW, V0_OLD, V1_OLD
            int BNEW, BOLD
            int[:] triangle_new
            bint found

        if vertices.shape[0] != self.size:
            raise ValueError('Expected {} interfaces, got {}'
                             .format(vertices.shape[0], self.size))

        if vertices.shape[1] != 2:
            raise ValueError('Each interfaces must have 2 vertices, got {}'
                             .format(vertices.shape[1]))

        check_consistancy = np.zeros(self.size, dtype='int32')
        triangle_new = np.empty_like(self.triangle)
        idx_new = np.empty_like(self.edge_map.idx)

        for BNEW in range(self.size):
            V0_NEW = vertices[BNEW, 0]
            V1_NEW = vertices[BNEW, 1]

            E = self.edge_map.search_edge_idx(V0_NEW, V1_NEW, &found)
            if not found or self.edge_map.location[E] != BOUNDARY_EDGE:
                raise ValueError('Edge {} with vertices ({},{}) not found'
                                 .format(BNEW, V0_NEW, V1_NEW))

            BOLD = self.edge_map.idx[E]

            check_consistancy[BOLD] += 1
            if check_consistancy[BOLD] > 1:
                raise ValueError("Edge ({}, {}) is duplicated"
                                 .format(V0_NEW, V1_NEW))

            V0_OLD = self.vertices[BOLD, 0]
            V1_OLD = self.vertices[BOLD, 1]

            if V0_NEW == V0_OLD and V1_NEW == V1_OLD:
                triangle_new[BNEW] = self.triangle[BOLD]

            elif V0_NEW == V1_OLD and V1_NEW == V0_OLD:
                raise ValueError('Edge ({}, {}) is not direct'
                                 .format(V0_NEW, V1_NEW))

            else:
                raise RuntimeError(
                    "Expected vertices ({}, {}), but got vertices ({}, {})"
                    .format(V0_NEW, V1_NEW, V0_OLD, V1_OLD))

            idx_new[E] = BNEW

        self.edge_map.idx = idx_new
        self.triangle = triangle_new
        self.vertices = vertices

    def finalize(BoundaryEdges self):
        """
        Create next boundary edge
        """
        cdef:
            int B, V0, V1, V2
        for B in range(self.size):
            V0 = self.vertices[B, 0]
            V1 = self.vertices[B, 1]
            E = self.edge_map.search_next_boundary_edge(V0, V1)
            if E == -1:
                raise ValueError(
                    "Can't find boundary edge connected by vertice {} to"
                    " boundary edge of vertices ({},{})".format(V1, V0, V1)
                )
            else:
                self.next_boundary_edge[B] = E

    def add_label(BoundaryEdges self, int[:,:] label):
        cdef:
            int R, NR = label.shape[0]
            int V0, V1
            int B
            int[:] count

        if NR != self.size:
            raise ValueError(
                "{} label are given, but there are {} boundary edges"
                .format(NR, self.size))

        self.label = np.empty(self.size, dtype='int32')

        count = np.zeros(self.size, dtype='int32')

        for R in range(NR):
            V0 = label[R,0]
            V1 = label[R,1]

            B = self.index_of(V0, V1)

            self.label[B] = label[R,2]
            count[B] += 1

        for B in range(self.size):
            if count[B] == 0:
                V0 = self.vertices[B, 0]
                V1 = self.vertices[B, 1]
                raise ValueError(
                    "Missing label for edge ({}, {})".format(V0, V1))
            elif count[B] > 1:
                V0 = self.vertices[B, 0]
                V1 = self.vertices[B, 1]
                raise ValueError(
                    "Reference for edge ({}, {}) is given {} times"
                    .format(V0, V1, count[B]))

    def compute_length(BoundaryEdges self, double[:] x, double[:] y):
        cdef:
            int B, V0, V1
            CPoint2D P0, P1

        self.length = np.empty(self.size, dtype='d')

        for B in range(self.size):
            V0 = self.vertices[B, 0]
            V1 = self.vertices[B, 1]

            P0.x = x[V0]
            P0.y = y[V0]

            P1.x = x[V1]
            P1.y = y[V1]

            self.length[B] = c_point2d_distance(&P0, &P1)

    def compute_normal(BoundaryEdges self, double[:] x, double[:] y):
        cdef:
            int B, V0, V1
            double vec_norm
            CVector2D vec, normal

        self.normal = np.empty((self.size, 2), dtype='d')

        for B in range(self.size):
            V0 = self.vertices[B, 0]
            V1 = self.vertices[B, 1]

            vec.x = x[V1] - x[V0]
            vec.y = y[V1] - y[V0]

            vec_norm = compute_norm2d(&vec)
            compute_normal2d(&vec, vec_norm, &normal)

            self.normal[B, 0] = normal.x
            self.normal[B, 1] = normal.y


    def index_of(BoundaryEdges self, int V0, int V1):
        """
        Retrieve index for boundary edge(V0, V1)
        """

        cdef:
            int location
            int B, E
            int V0_, V1_
            bint found

        E = self.edge_map.search_edge_idx(V0, V1, &found)

        if not found:
            raise KeyError("No such boundary edge ({}, {})".format(V0, V1))

        location = self.edge_map.location[E]

        if location == BOUNDARY_EDGE:
            B = self.edge_map.idx[E]
            V0_ = self.vertices[B, 0]
            V1_ = self.vertices[B, 1]
            if not ((V0==V0_ and V1==V1_) or (V0==V1_ and V1==V0_)):
                raise RuntimeError(
                    "Expected vertices ({}, {}), but got vertices ({}, {})"
                    .format(V0, V1, V0_, V1_))
            return B

        elif location == INTERN_EDGE:
            raise KeyError("({}, {}) is an intern edge".format(V0, V1))

        else:
            RuntimeError("Unexpected edge location: {}".format(location))

    def __getitem__(self, V0V1):
        """
        Retrieve triangle for boundary edge (V0, V1).
        """
        cdef:
            int B, V0, V1
        V0, V1 = V0V1
        B = self.index_of(V0, V1)
        return self.triangle[B]
