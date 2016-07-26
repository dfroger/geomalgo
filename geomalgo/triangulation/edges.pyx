import numpy as np

from libc.stdlib cimport malloc

from .edge_to_triangle cimport (
    CEdgeToTriangles, Edge, edge_to_triangles_new, edge_to_triangle_del,
    edge_to_triangles_add, edge_to_triangles_get, edge_to_triangles_compute
)

cdef class BoundaryEdges:
    pass

cdef class InternEdges:
    property vertices:
        def __get__(self):
            return np.asarray(self.c_vertices)

# is_intern_edge
# boundary_vertex_neighbourg
def build_edges(int[:,:] trivtx, int NV):

    cdef:
        CEdgeToTriangles* edge2tri
        int I, B
        int NE, NI, NB
        int NT = trivtx.shape[0]
        int T, V0, V1, V2
        Edge* edge
        InternEdges intern = InternEdges()
        BoundaryEdges boundary = BoundaryEdges()

    edge2tri = edge_to_triangles_new(NV)
    edge_to_triangles_compute(edge2tri, trivtx)

    NE = edge2tri.NE
    NI = edge2tri.NI
    NB = edge2tri.NB

    intern.triangles   = <int[:NI,:2]> malloc(sizeof(int)*NI*2)
    intern.c_vertices    = <int[:NI,:2]> malloc(sizeof(int)*NI*2)
    boundary.triangles = <int[:NB]>    malloc(sizeof(int)*NB)
    boundary.vertices  = <int[:NB,:2]> malloc(sizeof(int)*NB*2)

    I = 0
    B = 0

    for V0 in range(edge2tri.size):
        edge = edge2tri.edges[V0]
        while edge != NULL:
            if edge.has_two_triangles:
                if edge.counterclockwise:
                    intern.c_vertices[I,0] = V0
                    intern.c_vertices[I,1] = edge.V1
                else:
                    intern.c_vertices[I,0] = edge.V1
                    intern.c_vertices[I,1] = V0
                intern.triangles[I,0] = edge.T0
                intern.triangles[I,1] = edge.T1
                I += 1
            else:
                boundary.vertices[B,0] = V0
                boundary.vertices[B,1] = edge.V1
                boundary.triangles[B] = edge.T0
                B += 1
            edge = edge.next_edge

    edge_to_triangle_del(edge2tri)

    return intern, boundary
