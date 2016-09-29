import numpy as np

from .constant cimport *


cdef class EdgeMap:
    """
    See TestStep.test_edge_map (test_edges.py)
    """

    def __init__(self, NV, NE):
        self.NV = NV
        self.NE = NE

        # For a vertice V0, give index bounds to search V1 in self.edges.
        self.bounds = np.empty(2*NV+1, dtype='int32')

        # Between self.edges[self.bounds[2*V0]:self.bounds[2*V0+1]] give all V1
        # connected to V0 such as V1 > V0.
        # Between self.edges[self.bounds[2*V0+1]:self.bounds[2*V0+2]] give all V1
        # connected to V0 such as V1 < V0.
        # Note that all vertice neighbours (vertices connected by edge) are
        # stored in a continuous memory block.
        self.edges = np.empty(2*NE, dtype='int32')

        # Whether to find edge in BoundaryEdges or InternEdges.
        self.location = np.empty(2*NE, dtype='int32')

        # At which index to find edge in BoundaryEdges or InternEdges.
        self.idx = np.empty(2*NE, dtype='int32')

    cdef (bint, int) search_edge_idx(EdgeMap self, int V0, int V1):
        cdef:
            int E, E0, E1
        if V0 > V1:
            V0, V1 = V1, V0
        if V0 >= self.NV:
            return False, 0
        E0, E1 = self.bounds[2*V0], self.bounds[2*V0+1]
        for E in range(E0, E1):
            if self.edges[E] == V1:
                return True, E
        else:
            return False, 0

    cdef int search_next_boundary_edge(EdgeMap self, int V0, int V1):
        """
        V5--V4--V3
        | \ | \ |
        V0--V1--V2

        Given boundary edge V0V1, search next boundary edge V1V2.
        """
        cdef:
            int E, E0, E1
            int location

        # Search a boundary edge in all edges connected to V1, that
        # is not V0V1.
        E0, E1 = self.bounds[2*V1], self.bounds[2*V1+2]
        for E in range(E0, E1):
            location = self.location[E]
            if location == BOUNDARY_EDGE and self.edges[E] != V0:
                return self.idx[E]
        else:
            return -1

    cpdef int[:] neighbours(EdgeMap self, int V0):
        return self.edges[self.bounds[2*V0]:self.bounds[2*V0+2]]
