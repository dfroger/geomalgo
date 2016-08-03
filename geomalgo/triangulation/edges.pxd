cdef enum EdgeLocation:
    intern = 0
    boundary = 1
    not_found = 2

cdef class BoundaryEdges:
    cdef public:
        int[:,:] vertices
        int[:] triangles


cdef class InternEdges:
    cdef public:
        int[:,:] vertices
        int[:,:] triangles


cdef class EdgeMap:
    cdef public:
        int[:] bounds
        int[:] edges
        int[:] location
        int[:] idx
