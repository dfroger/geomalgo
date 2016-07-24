"""
Efficiently maps edge to triangles they belong to.

For example, with this mesh:

    3-------4-------5
    | \   2 | \   3 |
    |   \   |   \   |
    | 0   \ | 1   \ |
    0-------1-------2

this module provides the mapping (V0,V1) -> (T0, T1), with V1>V0:
    {
    (0, 1): (0, None),
    (0, 3): (0, None),
    (1, 2): (1, None),
    (1, 3): (0, 2),
    (1, 4): (1, 2),
    (2, 4): (1, 3),
    (2, 5): (3, None),
    (3, 4): (2, None),
    (4, 5): (3, None),
    }

To provides this mapping (V0,V1) -> (T0,T1), an array of `Edge*` is
indexed with V0, and returns a linked list of edges connected to V0,
with V1 > V0:

[
V0=0 -> Edge(V1=1, T0=0), Edge(V1=3, T0=0)
V0=1 -> Edge(V1=2, T0=1), Edge(V1=3, T0=0, T1=2), Edge(V1=4, T0=1, T1=2)
V0=2 -> Edge(V1=4, T0=1, T1=3), Edge(V1=5, T0=3)
V0=3 -> Edge(V1=4, T0=2)
V0=4 -> Edge(V1=5, T0=3)
]

"""

from libc.stdlib cimport malloc, free


cdef Edge* edge_new(int V1, int T0):
    cdef:
        Edge* edge
    edge = <Edge*> malloc(sizeof(Edge))
    edge.V1 = V1
    edge.has_two_triangles = False
    edge.T0 = T0
    # T1 needs no initialization.
    edge.next_edge = NULL
    return edge


cdef CEdgeToTriangles* edge_to_triangles_new(int NV):
    cdef:
        CEdgeToTriangles* edge_to_triangles
        int size, i
    # Allocate and initialize main CEdgeToTriangles structure.
    edge_to_triangles =  <CEdgeToTriangles*> malloc(sizeof(CEdgeToTriangles))
    size = NV - 1
    edge_to_triangles.size = size
    edge_to_triangles.edges_number = 0
    # Allocate array of linked list of `Edge*`.
    edge_to_triangles.edges = <Edge**> malloc(sizeof(Edge*)*size)
    # Each linked list is just one Edge* with value NULL.
    for i in range(size):
        edge_to_triangles.edges[i] = NULL
    return edge_to_triangles


cdef void edge_to_triangle_del(CEdgeToTriangles* edge_to_triangles):
    cdef:
        int V0
        Edge* tmp
    # First, free each item of each Edge* linked list.
    for V0 in range(edge_to_triangles.size):
        edge = edge_to_triangles.edges[V0]
        while edge != NULL:
            tmp = edge.next_edge
            free(edge)
            edge = tmp
    # Free the array of linked list.
    free(edge_to_triangles.edges)
    # Free the main structure.
    free(edge_to_triangles)


cdef void edge_to_triangles_add(CEdgeToTriangles* edge_to_triangles,
                                int V0, int V1, int T):
    cdef:
        Edge** edge_ptr
    # Order (V0, V1) such as V0 > V1.
    if V0 > V1:
        V0, V1 = V1, V0
    # Seach if (V0, V1) is already associated to a T0.
    # Take the address of the first Edge* in the linked list.
    # Note that the value of edge may be modified, so we need
    # its adress.
    edge_ptr = edge_to_triangles.edges + V0
    # Loop on the Edge* linked list until the end.
    while edge_ptr[0] != NULL:
        # (V0, V1) is already associated with T0. Now ssociated it with T1,
        # too.
        if edge_ptr[0].V1 == V1:
            edge_ptr[0].has_two_triangles = True
            edge_ptr[0].T1 = T
            break
        # Move to the next item in `Edge*` linked list.
        edge_ptr= &(edge_ptr[0].next_edge)
    else:
        # (V0, V1) not yet in the `Edge*` linked list, create a new
        # `Edge*` at the end of the linked list.
        # Note that this requires a pointer to the
        edge_ptr[0] = edge_new(V1, T)
        edge_to_triangles.edges_number += 1


cdef Edge* edge_to_triangles_get(CEdgeToTriangles* edge_to_triangles,
                                 int V0, int V1):
    cdef:
        Edge* edge
    # Order (V0, V1) such as V0 > V1.
    if V0 > V1:
        V0, V1 = V1, V0
    # Get the linked list of `Edge*` connected to V0.
    edge = edge_to_triangles.edges[V0]
    # Loop on each `Edge*` connected to V0, and check if V1 is found.
    while edge != NULL:
        if edge.V1 == V1:
            return edge
        edge = edge.next_edge
    else:
        return NULL


cdef class EdgeToTriangles:
    """Mapping from edge to triangles the belongs to"""

    def __cinit__(self, int[:,:] trivtx, int NV):
        self._edge_to_triangles = edge_to_triangles_new(NV)

    def __dealloc__(self):
        edge_to_triangle_del(self._edge_to_triangles)

    def __init__(self, int[:,:] trivtx, int NV):
        cdef:
            int T, NT = trivtx.shape[0]
            int V0, V1, V2

        # Loop on each triangle vertices (V0,V1,V2), and marks the
        # edges (V0,V1), (V1,V2), (V2,V0) to belongs to the triangle.
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
