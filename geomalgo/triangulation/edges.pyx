import numpy as np

from .edge_to_triangle cimport (
    CEdgeToTriangles, Edge, edge_to_triangles_new, edge_to_triangle_del,
    edge_to_triangles_compute
)


cdef class EdgeMap:
    """
    See TestStep.test_edge_map (test_edges.py)
    """

    def __init__(self, NV, NE):
        # For a vertice V0, give index bounds to search V1 in self.edges.
        self.bounds = np.empty(NV, dtype='int32')

        # Between self.edges[self.bounds[V0]:self.bounds[V0+1]] give all V1
        # connected to V0 such as V1 > V0.
        self.edges = np.empty(NE, dtype='int32')

        # Whether to find edge in BoundaryEdges or InternEdges.
        self.location = np.empty(NE, dtype='int32')

        # At which index to find edge in BoundaryEdges or InternEdges.
        self.idx = np.empty(NE, dtype='int32')

    cdef (EdgeLocation, int) search_edge(EdgeMap self, int V0, int V1):
        cdef:
            int I, B, C
        if V0 > V1:
            V0, V1 = V1, V0
        B, C = self.bounds[V0], self.bounds[V0+1]
        for I in range(B, C):
            if self.edges[I] == V1:
                return <EdgeLocation> self.location[I], self.idx[I]
        else:
            return EdgeLocation.not_found, 0


cdef class BoundaryEdges:
    """
    Boundary edges are stored such that (V0, V1, T) is counterclockwise
    """

    def __init__(self, NB):
        self.vertices = np.empty((NB, 2), dtype='int32')
        self.triangles = np.empty((NB,), dtype='int32')

    def __getitem__(self, V0V1):
        """
        Retrieve triangles for boundary edge (V0, V1).
        """
        cdef:
            EdgeLocation location
            int B
            int V0, V1, V0_, V1_

        V0, V1 = V0V1

        location, B = self.edge_map.search_edge(V0, V1)

        if location == EdgeLocation.boundary:
            V0_ = self.vertices[B, 0]
            V1_ = self.vertices[B, 1]
            if not ((V0==V0_ and V1==V1_) or (V0==V1_ and V1==V0_)):
                raise RuntimeError(
                    "Expected vertices ({}, {}), but got vertices ({}, {})"
                    .format(V0, V1, V0_, V1_))
            return self.triangles[B]

        elif location == EdgeLocation.intern:
            raise KeyError("({}, {}) is an intern edge".format(V0, V1))

        elif location == EdgeLocation.not_found:
            raise KeyError("No such boundary edge ({}, {})".format(V0, V1))

        else:
            RuntimeError("Unexpected EdgeLocation value: {}".format(location))


cdef class InternEdges:
    """
    Intern edges vertices (V0, V1) are stored such as V0 < V1, and
    sorted on increasing V0.

    (V0, V1, T0) is counterclockwise, and (V0, V1, T1) is clockwise.
    """

    def __init__(self, NI):
        self.vertices = np.empty((NI, 2), dtype='int32')
        self.triangles = np.empty((NI, 2), dtype='int32')

    def __getitem__(self, V0V1):
        """
        Retrive triangles for intern edge (V0, V1).
        """
        cdef:
            EdgeLocation location
            int I
            int V0, V1, V0_, V1_

        V0, V1 = V0V1

        location, I = self.edge_map.search_edge(V0, V1)

        if location == EdgeLocation.intern:
            V0_ = self.vertices[I, 0]
            V1_ = self.vertices[I, 1]
            if not ((V0==V0_ and V1==V1_) or (V0==V1_ and V1==V0_)):
                raise RuntimeError(
                    "Expected vertices ({}, {}), but got vertices ({}, {})"
                    .format(V0, V1, V0_, V1_))
            return np.asarray(self.triangles[I], dtype='int32')

        elif location == EdgeLocation.boundary:
            raise KeyError("({}, {}) is a boundary edge".format(V0, V1))

        elif location == EdgeLocation.not_found:
            raise KeyError("No such intern edge ({}, {})".format(V0, V1))

        else:
            RuntimeError("Unexpected EdgeLocation value: {}".format(location))

def build_edges(int[:,:] trivtx, int NV):

    cdef:
        CEdgeToTriangles* edge2tri
        int E, I, B
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
    edge_map = EdgeMap(NV, NE)

    cdef:
        int[:,:] boundary_vertices = boundary_edges.vertices
        int[:] boundary_triangles = boundary_edges.triangles
        int[:,:] intern_vertices = intern_edges.vertices
        int[:,:] intern_triangles = intern_edges.triangles

    E = 0
    I = 0
    B = 0

    edge_map.bounds[0] = 0

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
                edge_map.location[E] = EdgeLocation.intern
                edge_map.idx[E] = I
                I += 1
            else:
                if edge.counterclockwise:
                    boundary_vertices[B,0] = V0
                    boundary_vertices[B,1] = edge.V1
                else:
                    boundary_vertices[B,0] = edge.V1
                    boundary_vertices[B,1] = V0
                boundary_triangles[B] = edge.T0
                edge_map.location[E] = EdgeLocation.boundary
                edge_map.idx[E] = B
                B += 1
            edge_map.edges[E] = edge.V1
            edge = edge.next_edge
            E += 1
        edge_map.bounds[V0+1] = E

    edge_to_triangle_del(edge2tri)

    intern_edges.edge_map = edge_map
    boundary_edges.edge_map = edge_map

    return intern_edges, boundary_edges
