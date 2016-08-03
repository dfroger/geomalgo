cdef class BoundaryEdges:
    cdef public:
        int[:,:] vertices
        int[:] triangles

cdef class InternEdges:
    cdef public:
        int[:,:] vertices
        int[:,:] triangles

