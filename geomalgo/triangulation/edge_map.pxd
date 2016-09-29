cdef class EdgeMap:
    cdef public:
        int NV
        int NE
        int[:] bounds
        int[:] edges
        int[:] location
        int[:] idx

    cdef (bint, int) search_edge_idx(EdgeMap self, int V0, int V1)

    cdef int search_next_boundary_edge(EdgeMap self, int V0, int V1)

    cpdef int[:] neighbours(EdgeMap self, int V0)
