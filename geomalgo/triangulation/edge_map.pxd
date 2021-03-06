cdef class EdgeMap:
    cdef public:
        int NV
        int NE
        int[:] bounds
        int[:] edges
        int[:] location
        int[:] idx

    cdef int search_edge_idx(EdgeMap self, int V0, int V1, bint* found)

    cdef int search_next_boundary_edge(EdgeMap self, int V0, int V1)

    cdef int search_edge_idx_inf(EdgeMap self, int V0, int V1, bint* found)

    cpdef int[:] neighbours(EdgeMap self, int V0)
