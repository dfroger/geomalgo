from collections.abc import Mapping

# An edge (V0,V1), with V1>V0 is stored in an array at index V0. (V0,V1) may
# belong to 1 triangle (if it is a boundary edge), or 2 triangles (if it is an
# internal edge). `next_edge` points to the next edge connected to V0, or has
# value NULL.
cdef struct Edge:
    int V1
    bint has_two_triangles
    int T0
    int T1
    Edge* next_edge

# Edge** is an array of linked list of `Edge*`, indexed with V0, with V1>V0.
# It has size = NV -1 (with NV the number of vertices), because by definition,
# last V0 vertice is not connected to a V1 vertice such as V0 > V1.
# `edges_number` counts the total number of `Edges` in each linked list.
cdef struct CEdgeToTriangles:
    # Number of vertices - 1
    int size
    # Number of edges (NI+NB)
    int NE
    # Number of internal edges.
    int NI
    # Number of boundary edges
    int NB
    Edge** edges

# Allocate and initialize a new `Edge`.
cdef Edge* edge_new(int V1, int T0)

# Allocate and initialize a new edge_to_triangles_new.
cdef CEdgeToTriangles* edge_to_triangles_new(int NV)

# Delete a `CEdgeToTriangles`.
cdef void edge_to_triangle_del(CEdgeToTriangles* edge_to_triangles)

# Add a new (V0,V1) -> T entry in the mapping.
cdef void edge_to_triangles_add(CEdgeToTriangles* edge_to_triangles,
                                int V0, int V1, int T)

# Compute all (V0,V1) -> (T0, T1) mappings
cdef void edge_to_triangles_compute(CEdgeToTriangles* edge_to_triangles,
                                    int[:,:] trivtx)

# Retrieve a (V0,V1) -> (T0, T1) entry.
cdef Edge* edge_to_triangles_get(CEdgeToTriangles* edge_to_triangles,
                                       int V0, int V1)
cdef class EdgeToTriangles:
    cdef:
        CEdgeToTriangles* _edge2tri
    cdef public:
        int NE
        int NI
        int NB
