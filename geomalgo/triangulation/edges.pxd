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
        bint[:] is_intern
        int[:] idx
