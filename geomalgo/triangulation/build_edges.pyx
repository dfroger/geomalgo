import numpy as np

from .constant cimport *
from .edge_map cimport EdgeMap
from .boundary_edges cimport BoundaryEdges
from .intern_edges cimport InternEdges

from .edge_to_triangle cimport (
    CEdgeToTriangles, Edge, InferiorEdge, edge_to_triangles_new,
    edge_to_triangle_del, edge_to_triangles_compute
)


def build_edges(int[:,:] trivtx, int NV, intern_edges_order=None,
                boundary_edges_order=None):

    cdef:
        CEdgeToTriangles* edge2tri
        int E, I, B, E0, E1
        int NE, NI, NB
        int NT = trivtx.shape[0]
        int T, V0, V1, V2
        Edge* edge
        InferiorEdge * inferior_edge
        bint found

    edge2tri = edge_to_triangles_new(NV)
    edge_to_triangles_compute(edge2tri, trivtx)

    NE = edge2tri.NE
    NI = edge2tri.NI
    NB = edge2tri.NB

    boundary_edges = BoundaryEdges(NB)
    intern_edges = InternEdges(NI)
    edge_map = EdgeMap(NV, NE)

    cdef:
        int[:,:] boundary_vertices = boundary_edges.vertices
        int[:] boundary_triangle = boundary_edges.triangle
        int[:,:] intern_vertices = intern_edges.vertices
        int[:,:] intern_triangles = intern_edges.triangles

    E = 0
    I = 0
    B = 0

    edge_map.bounds[0] = 0

    for V0 in range(edge2tri.NV):
        # Edge
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
                edge_map.location[E] = INTERN_EDGE
                edge_map.idx[E] = I
                I += 1
            else:
                if edge.counterclockwise:
                    boundary_vertices[B,0] = V0
                    boundary_vertices[B,1] = edge.V1
                else:
                    boundary_vertices[B,0] = edge.V1
                    boundary_vertices[B,1] = V0
                boundary_triangle[B] = edge.T0
                edge_map.location[E] = BOUNDARY_EDGE
                edge_map.idx[E] = B
                B += 1
            edge_map.edges[E] = edge.V1
            edge = edge.next_edge
            E += 1
        edge_map.bounds[2*V0+1] = E

        # InferiorEdge
        inferior_edge = edge2tri.inferior_edges[V0]
        while inferior_edge != NULL:
            edge_map.edges[E] = inferior_edge.V0
            inferior_edge = inferior_edge.next_inferior_edge
            E += 1
        edge_map.bounds[2*V0+2] = E

    # Fill location and idx for inferior edges
    for V1 in range(edge2tri.NV):
        E0, E1 = edge_map.bounds[2*V1+1], edge_map.bounds[2*V1+2]
        for Einf in range(E0, E1):
            V0 = edge_map.edges[Einf]
            E = edge_map.search_edge_idx(V0, V1, &found)
            edge_map.idx[Einf] = edge_map.idx[E]
            edge_map.location[Einf] = edge_map.location[E]

    edge_to_triangle_del(edge2tri)

    intern_edges.edge_map = edge_map
    if intern_edges_order is not None:
        intern_edges.reorder(intern_edges_order)

    boundary_edges.edge_map = edge_map
    if boundary_edges_order is not None:
        boundary_edges.reorder(boundary_edges_order)
    boundary_edges.build_next_boundary_edge()

    return intern_edges, boundary_edges, edge_map
