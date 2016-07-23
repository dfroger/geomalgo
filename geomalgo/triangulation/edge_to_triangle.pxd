from collections.abc import Mapping

cdef struct Edge:
    int V1
    bint has_two_triangles
    int T0
    int T1
    Edge* next_edge

cdef struct CEdgeToTriangles:
    int size
    int edges_number
    Edge** edges

cdef Edge* edge_new(int V1, int T0)

cdef CEdgeToTriangles* edge_to_triangles_new(int NV)

cdef void edge_to_triangle_del(CEdgeToTriangles* edge_to_triangles)

cdef void edge_to_triangles_add(CEdgeToTriangles* edge_to_triangles,
                                int V0, int V1, int tri)

cdef Edge* edge_to_triangles_get(CEdgeToTriangles* edge_to_triangles,
                                       int V0, int V1)
cdef class EdgeToTriangles:
    cdef:
        CEdgeToTriangles* _edge_to_triangles
