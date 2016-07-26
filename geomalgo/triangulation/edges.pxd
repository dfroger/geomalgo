cdef class BoundaryEdges:
    cdef public:
        int[:,:] vertices
        #int[:,:,] vertices
        int[:] triangles

cdef class InternEdges:
    cdef public:
        int[:,:] c_vertices
        int[:,:] triangles

# TODO:
# connected vertices
# connected triangles
