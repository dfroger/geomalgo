cdef enum EdgeLocation:
    intern = 0
    boundary = 1
    not_found = 2


cdef class EdgeMap:
    cdef public:
        int[:] bounds
        int[:] edges
        int[:] location
        int[:] idx

    cdef int search_edge(EdgeMap self, int V0, int V1,
                         EdgeLocation* edge_location)

    cdef int search_next_boundary_edge(EdgeMap self, int V0, int V1)

cdef class BoundaryEdges:
    cdef public:
        int size
        int[:,:] vertices
        int[:] triangles
        int[:] next_boundary_edge
        int[:] references
        EdgeMap edge_map


cdef class InternEdges:
    cdef public:
        int size
        int[:,:] vertices
        int[:,:] triangles
        EdgeMap edge_map


