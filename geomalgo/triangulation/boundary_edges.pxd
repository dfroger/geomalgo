from .edge_map cimport EdgeMap

cdef class BoundaryEdges:
    cdef public:
        int size
        int[:,:] vertices
        int[:] triangle
        int[:] next_boundary_edge
        int[:] label
        double[:] length
        double[:,:] normal
        EdgeMap edge_map
