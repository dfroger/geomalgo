# An edge (V0,V1), with V1>V0 is stored in an array at index V0. (V0,V1) may
# belong to 1 triangle (if it is a boundary edge), or 2 triangles (if it is an
# internal edge). `next_edge` points to the next edge connected to V0, or has
# value NULL.
cdef struct Edge:
    int V1
    bint has_two_triangles
    int T0
    int T1
    # If True, (T0, V0, V1) is counterclockwise and (T1, V0, V1) is clockwise.
    # If False, (T0, V0, V1) is clockwise and (T1, V0, V1) is
    # counterclockwise.
    bint counterclockwise
    Edge* next_edge

# Edges (V0,V1) with V1<V0. This store duplicated edge, as (V0,V1) is stored
# in Edge, and (V1,V0) is InferiorEdge. Given a vertice V0, this allow to
# find all V1 vertice connected by edge with 0(1) performance.
cdef struct InferiorEdge:
    int V0
    InferiorEdge* next_inferior_edge

# Edge** is an array of linked list of `Edge*`, indexed with V0, with V1>V0.
# `edges_number` counts the total number of `Edges` in each linked list.
cdef struct CEdgeToTriangles:
    # Number of vertices
    int NV
    # Number of edges (NI+NB)
    int NE
    # Number of internal edges.
    int NI
    # Number of boundary edges
    int NB
    Edge** edges
    InferiorEdge** inferior_edges

# Allocate and initialize a new `Edge`.
cdef Edge* edge_new(int V1, int T0, bint counterclockwise)

# Allocate and initialize a new `InferiorEdge`.
cdef InferiorEdge* inferior_edge_new(int V1)

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

cdef void edge_to_triangles_display(CEdgeToTriangles* edge2tri)

cdef class EdgeToTriangles:
    cdef:
        CEdgeToTriangles* _edge2tri
    cdef public:
        int NE
        int NI
        int NB
