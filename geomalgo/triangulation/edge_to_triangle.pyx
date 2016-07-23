from libc.stdlib cimport malloc, free
from libc.stdio cimport printf

cdef Edge* edge_new(int V1, int T0):
    cdef:
        Edge* edge
    edge = <Edge*> malloc(sizeof(Edge))
    edge.V1 = V1
    edge.has_two_triangles = False
    edge.T0 = T0
    edge.next_edge = NULL
    return edge


cdef CEdgeToTriangles* edge_to_triangles_new(int NV):
    cdef:
        CEdgeToTriangles* edge_to_triangles
        int size, i
    edge_to_triangles =  <CEdgeToTriangles*> malloc(sizeof(CEdgeToTriangles))
    size = NV - 1
    edge_to_triangles.size = size
    edge_to_triangles.edges_number = 0
    edge_to_triangles.edges = <Edge**> malloc(sizeof(Edge*)*size)
    for i in range(size):
        edge_to_triangles.edges[i] = NULL
    return edge_to_triangles

cdef void edge_to_triangle_del(CEdgeToTriangles* edge_to_triangles):
    cdef:
        int V0
        Edge* tmp
    for V0 in range(edge_to_triangles.size):
        edge = edge_to_triangles.edges[V0]
        while edge != NULL:
            tmp = edge.next_edge
            free(edge)
            edge = tmp
    free(edge_to_triangles.edges)
    free(edge_to_triangles)

cdef void edge_to_triangles_add(CEdgeToTriangles* edge_to_triangles,
                                int V0, int V1, int T):
    cdef:
        Edge** edge_ptr
    if V0 > V1:
        V0, V1 = V1, V0
    edge_ptr = edge_to_triangles.edges + V0
    # Seach if (V0, V1) is already associated to a triangle.
    while edge_ptr[0] != NULL:
        if edge_ptr[0].V1 == V1:
            edge_ptr[0].has_two_triangles = True
            edge_ptr[0].T1 = T
            break
        edge_ptr= &(edge_ptr[0].next_edge)
    else:
        edge_ptr[0] = edge_new(V1, T)
        edge_to_triangles.edges_number += 1

cdef Edge* edge_to_triangles_get(CEdgeToTriangles* edge_to_triangles,
                                 int V0, int V1):
    cdef:
        Edge* edge
    if V0 > V1:
        V0, V1 = V1, V0
    edge = edge_to_triangles.edges[V0]
    while edge != NULL:
        if edge.V1 == V1:
            return edge
        edge = edge.next_edge
    else:
        return NULL

cdef void edge_to_triangles_display(CEdgeToTriangles* edge_to_triangles):
    cdef:
        int V0
        Edge* edge
    printf("Number of edges: %d\n", edge_to_triangles.edges_number)
    for V0 in range(edge_to_triangles.size):
        printf("--------------\n")
        edge = edge_to_triangles.edges[V0]
        while edge != NULL:
            if edge.has_two_triangles:
                printf("(%d, %d): (%d, %d)\n", V0, edge.V1, edge.T0, edge.T1)
            else:
                printf("(%d, %d): %d\n", V0, edge.V1, edge.T0)
            edge = edge.next_edge

cdef class EdgeToTriangles:

    def __cinit__(self, int[:,:] trivtx, int NV):
        self._edge_to_triangles = edge_to_triangles_new(NV)

    def __dealloc__(self):
        edge_to_triangle_del(self._edge_to_triangles)

    def __init__(self, int[:,:] trivtx, int NV):
        cdef:
            int T, NT = trivtx.shape[0]
            int V0, V1, V2

        for T in range(NT):
            V0 = trivtx[T,0]
            V1 = trivtx[T,1]
            V2 = trivtx[T,2]
            edge_to_triangles_add(self._edge_to_triangles, V0, V1, T)
            edge_to_triangles_add(self._edge_to_triangles, V1, V2, T)
            edge_to_triangles_add(self._edge_to_triangles, V2, V0, T)

    def __getitem__(self, V0V1):
        cdef:
            int V0, V1
            Edge* edge
        V0 = V0V1[0]
        V1 = V0V1[1]
        edge = edge_to_triangles_get(self._edge_to_triangles, V0, V1)
        if edge == NULL:
            raise KeyError("No such edge: ({}, {})".format(V0, V1))
        if edge.has_two_triangles:
            return edge.T0, edge.T1
        else:
            return edge.T0, None

    def __len__(self):
        return self._edge_to_triangles.edges_number

    def display(self):
        edge_to_triangles_display(self._edge_to_triangles)
