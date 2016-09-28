cdef class EdgeMap:
    cdef public:
        int[:] bounds
        int[:] edges
        int[:] location
        int[:] idx

    cdef int search_edge(EdgeMap self, int V0, int V1,
                         int* edge_location)

    cdef int search_next_boundary_edge(EdgeMap self, int V0, int V1)

    cpdef int[:] neighbours(EdgeMap self, int V0)
