from .edge_map cimport EdgeMap

cdef class InternEdges:
    cdef public:
        int size
        int[:,:] vertices
        int[:,:] triangles
        EdgeMap edge_map

