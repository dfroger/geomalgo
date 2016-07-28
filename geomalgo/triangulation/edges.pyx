import numpy as np

from libc.stdlib cimport malloc

from .edge_to_triangle cimport (
    CEdgeToTriangles, Edge, edge_to_triangles_new, edge_to_triangle_del,
    edge_to_triangles_add, edge_to_triangles_get, edge_to_triangles_compute
)

class BoundaryEdges:
    def __init__(self, NB):
        self.vertices = np.empty((NB, 2), dtype='int32')
        self.triangles = np.empty((NB,), dtype='int32')

class InternEdges:
    def __init__(self, NI):
        self.vertices = np.empty((NI, 2), dtype='int32')
        self.triangles = np.empty((NI, 2), dtype='int32')

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

    edge2tri = edge_to_triangles_new(NV)
    edge_to_triangles_compute(edge2tri, trivtx)

    NE = edge2tri.NE
    NI = edge2tri.NI
    NB = edge2tri.NB

    boundary_edges = BoundaryEdges(NB)
    intern_edges = InternEdges(NI)

    cdef:
        int[:,:] boundary_vertices = boundary_edges.vertices
        int[:] boundary_triangles = boundary_edges.triangles
        int[:,:] intern_vertices = intern_edges.vertices
        int[:,:] intern_triangles = intern_edges.triangles

    I = 0
    B = 0

    for V0 in range(edge2tri.size):
        edge = edge2tri.edges[V0]
        while edge != NULL:
            if edge.has_two_triangles:
                intern_vertices[I,0] = V0
                intern_vertices[I,1] = edge.V1
                if edge.counterclockwise:
                    intern_triangles[I,0] = edge.T0
                    intern_triangles[I,1] = edge.T1
                else:
                    intern_triangles[I,0] = edge.T1
                    intern_triangles[I,1] = edge.T0
                I += 1
            else:
                if edge.counterclockwise:
                    boundary_vertices[B,0] = V0
                    boundary_vertices[B,1] = edge.V1
                else:
                    boundary_vertices[B,0] = edge.V1
                    boundary_vertices[B,1] = V0
                boundary_triangles[B] = edge.T0
                B += 1
            edge = edge.next_edge

    edge_to_triangle_del(edge2tri)

    return intern_edges, boundary_edges
