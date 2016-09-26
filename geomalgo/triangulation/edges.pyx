import numpy as np

from ..base2d.point2d cimport (
    CPoint2D, c_point2d_distance
)

from ..base2d.vector2d cimport (
    CVector2D, compute_normal2d, compute_norm2d
)

from .edge_to_triangle cimport (
    CEdgeToTriangles, Edge, InferiorEdge, edge_to_triangles_new,
    edge_to_triangle_del, edge_to_triangles_compute
)


cdef class EdgeMap:
    """
    See TestStep.test_edge_map (test_edges.py)
    """

    def __init__(self, NV, NE):
        # For a vertice V0, give index bounds to search V1 in self.edges.
        self.bounds = np.empty(2*NV+1, dtype='int32')

        # Between self.edges[self.bounds[2*V0]:self.bounds[2*V0+1]] give all V1
        # connected to V0 such as V1 > V0.
        # Between self.edges[self.bounds[2*V0+1]:self.bounds[2*V0+2]] give all V1
        # connected to V0 such as V1 < V0.
        # Note that all vertice neighbours (vertices connected by edge) are
        # stored in a continuous memory block.
        self.edges = np.empty(2*NE, dtype='int32')

        # Whether to find edge in BoundaryEdges or InternEdges.
        self.location = np.empty(2*NE, dtype='int32')

        # At which index to find edge in BoundaryEdges or InternEdges.
        self.idx = np.empty(2*NE, dtype='int32')

    cdef int search_edge(EdgeMap self, int V0, int V1,
                         EdgeLocation* edge_location):
        cdef:
            int E, E0, E1
        if V0 > V1:
            V0, V1 = V1, V0
        E0, E1 = self.bounds[2*V0], self.bounds[2*V0+1]
        for E in range(E0, E1):
            if self.edges[E] == V1:
                edge_location[0] = <EdgeLocation> self.location[E]
                return self.idx[E]
        else:
            edge_location[0] = EdgeLocation.not_found
            return 0

    cdef int search_next_boundary_edge(EdgeMap self, int V0, int V1):
        """
        V5--V4--V3
        | \ | \ |
        V0--V1--V2

        Given boundary edge V0V1, search next boundary edge V1V2.
        """
        cdef:
            int E, E0, E1
            EdgeLocation location

        # Search a boundary edge in all edges connected to V1, that
        # is not V0V1.
        E0, E1 = self.bounds[2*V1], self.bounds[2*V1+2]
        for E in range(E0, E1):
            location = <EdgeLocation> self.location[E]
            if location == EdgeLocation.boundary and self.edges[E] != V0:
                return self.idx[E]
        else:
            return -1


cdef class BoundaryEdges:
    """
    Boundary edges are stored such that (V0, V1, T) is counterclockwise
    """

    def __init__(self, size):
        self.size = size
        self.vertices = np.empty((size, 2), dtype='int32')
        self.triangle = np.empty(size, dtype='int32')
        self.next_boundary_edge = np.empty(size, dtype='int32')

    def finalize(BoundaryEdges self):
        """
        Create next boundary edge
        """
        cdef:
            int B, V0, V1, V2
        for B in range(self.size):
            V0 = self.vertices[B, 0]
            V1 = self.vertices[B, 1]
            E = self.edge_map.search_next_boundary_edge(V0, V1)
            if E == -1:
                raise ValueError(
                    "Can't find boundary edge connected by vertice {} to"
                    " boundary edge of vertices ({},{})".format(V1, V0, V1)
                )
            else:
                self.next_boundary_edge[B] = E

    def add_label(BoundaryEdges self, int[:,:] label):
        cdef:
            int R, NR = label.shape[0]
            int V0, V1
            int B
            int[:] count

        if NR != self.size:
            raise ValueError(
                "{} label are given, but there are {} boundary edges"
                .format(NR, self.size))

        self.label = np.empty(self.size, dtype='int32')

        count = np.zeros(self.size, dtype='int32')

        for R in range(NR):
            V0 = label[R,0]
            V1 = label[R,1]

            B = self.index_of(V0, V1)

            self.label[B] = label[R,2]
            count[B] += 1

        for B in range(self.size):
            if count[B] == 0:
                V0 = self.vertices[B, 0]
                V1 = self.vertices[B, 1]
                raise ValueError(
                    "Missing label for edge ({}, {})".format(V0, V1))
            elif count[B] > 1:
                V0 = self.vertices[B, 0]
                V1 = self.vertices[B, 1]
                raise ValueError(
                    "Reference for edge ({}, {}) is given {} times"
                    .format(V0, V1, count[B]))

    def compute_length(BoundaryEdges self, double[:] x, double[:] y):
        cdef:
            int B, V0, V1
            CPoint2D P0, P1

        self.length = np.empty(self.size, dtype='d')

        for B in range(self.size):
            V0 = self.vertices[B, 0]
            V1 = self.vertices[B, 1]

            P0.x = x[V0]
            P0.y = y[V0]

            P1.x = x[V1]
            P1.y = y[V1]

            self.length[B] = c_point2d_distance(&P0, &P1)

    def compute_normal(BoundaryEdges self, double[:] x, double[:] y):
        cdef:
            int B, V0, V1
            double vec_norm
            CVector2D vec, normal

        self.normal = np.empty((self.size, 2), dtype='d')

        for B in range(self.size):
            V0 = self.vertices[B, 0]
            V1 = self.vertices[B, 1]

            vec.x = x[V1] - x[V0]
            vec.y = y[V1] - y[V0]

            vec_norm = compute_norm2d(&vec)
            compute_normal2d(&vec, vec_norm, &normal)

            self.normal[B, 0] = normal.x
            self.normal[B, 1] = normal.y


    def index_of(BoundaryEdges self, int V0, int V1):
        """
        Retrieve index for boundary edge(V0, V1)
        """

        cdef:
            EdgeLocation location
            int B
            int V0_, V1_

        B = self.edge_map.search_edge(V0, V1, &location)

        if location == EdgeLocation.boundary:
            V0_ = self.vertices[B, 0]
            V1_ = self.vertices[B, 1]
            if not ((V0==V0_ and V1==V1_) or (V0==V1_ and V1==V0_)):
                raise RuntimeError(
                    "Expected vertices ({}, {}), but got vertices ({}, {})"
                    .format(V0, V1, V0_, V1_))
            return B

        elif location == EdgeLocation.intern:
            raise KeyError("({}, {}) is an intern edge".format(V0, V1))

        elif location == EdgeLocation.not_found:
            raise KeyError("No such boundary edge ({}, {})".format(V0, V1))

        else:
            RuntimeError("Unexpected EdgeLocation value: {}".format(location))

    def __getitem__(self, V0V1):
        """
        Retrieve triangle for boundary edge (V0, V1).
        """
        cdef:
            int B, V0, V1
        V0, V1 = V0V1
        B = self.index_of(V0, V1)
        return self.triangle[B]


cdef class InternEdges:
    """
    Intern edges vertices (V0, V1) are stored such as V0 < V1, and
    sorted on increasing V0.

    (V0, V1, T0) is counterclockwise, and (V0, V1, T1) is clockwise.
    """

    def __init__(self, size):
        self.size = size
        self.vertices = np.empty((size, 2), dtype='int32')
        self.triangles = np.empty((size, 2), dtype='int32')

    def index_of(InternEdges self, int V0, int V1):
        """
        Retrieve index for intern edge(V0, V1)
        """
        cdef:
            EdgeLocation location
            int I
            int V0_, V1_

        I = self.edge_map.search_edge(V0, V1, &location)

        if location == EdgeLocation.intern:
            V0_ = self.vertices[I, 0]
            V1_ = self.vertices[I, 1]
            if not ((V0==V0_ and V1==V1_) or (V0==V1_ and V1==V0_)):
                raise RuntimeError(
                    "Expected vertices ({}, {}), but got vertices ({}, {})"
                    .format(V0, V1, V0_, V1_))
            return I

        elif location == EdgeLocation.boundary:
            raise KeyError("({}, {}) is a boundary edge".format(V0, V1))

        elif location == EdgeLocation.not_found:
            raise KeyError("No such intern edge ({}, {})".format(V0, V1))

        else:
            RuntimeError("Unexpected EdgeLocation value: {}".format(location))

    def __getitem__(self, V0V1):
        """
        Retrive triangles for intern edge (V0, V1).
        """
        cdef:
            int I, V0, V1
        V0, V1 = V0V1
        I = self.index_of(V0, V1)
        return np.asarray(self.triangles[I], dtype='int32')

def build_edges(int[:,:] trivtx, int NV):

    cdef:
        CEdgeToTriangles* edge2tri
        int E, I, B, E0, E1
        int NE, NI, NB
        int NT = trivtx.shape[0]
        int T, V0, V1, V2
        Edge* edge
        InferiorEdge * inferior_edge
        EdgeLocation location

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
                boundary_triangle[B] = edge.T0
                edge_map.location[E] = EdgeLocation.boundary
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
        for E in range(E0, E1):
            V0 = edge_map.edges[E]
            edge_map.idx[E] = edge_map.search_edge(V0, V1, &location)
            edge_map.location[E] = <int> location

    edge_to_triangle_del(edge2tri)

    intern_edges.edge_map = edge_map
    boundary_edges.edge_map = edge_map
    boundary_edges.finalize()

    return intern_edges, boundary_edges
