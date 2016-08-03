import unittest

import numpy as np
from numpy.testing import assert_equal

from geomalgo import build_edges
from geomalgo.data import step, hole

class TestStep(unittest.TestCase):

    def setUp(self):
        self.intern_edges, self.boundary_edges, self.edge_map = \
            build_edges(step.trivtx, step.NV)

    def test_internal_edges_vertices (self):
        vert = np.asarray(self.intern_edges.vertices)
        self.assertEqual(vert.shape, (step.NI, 2))
        assert_equal(vert[0], (1,3))
        assert_equal(vert[1], (1,4))
        assert_equal(vert[2], (2,4))
        assert_equal(vert[3], (3,4))
        assert_equal(vert[4], (4,6))

    def test_internal_edges_triangles (self):
        tri = np.asarray(self.intern_edges.triangles)
        self.assertEqual(tri.shape, (step.NI, 2))
        assert_equal(tri[0], (0,2))
        assert_equal(tri[1], (2,1))
        assert_equal(tri[2], (1,3))
        assert_equal(tri[3], (4,2))
        assert_equal(tri[4], (4,5))

    def test_boundary_edges_vertices(self):
        vert = np.asarray(self.boundary_edges.vertices)
        self.assertEqual(vert.shape, (step.NB, 2))
        assert_equal(vert[0], (0,1))
        assert_equal(vert[1], (3,0))
        assert_equal(vert[2], (1,2))
        assert_equal(vert[3], (2,5))
        assert_equal(vert[4], (6,3))
        assert_equal(vert[5], (5,4))
        assert_equal(vert[6], (4,7))
        assert_equal(vert[7], (7,6))

    def test_boundary_edges_triangles(self):
        tri = np.asarray(self.boundary_edges.triangles)
        self.assertEqual(tri.shape, (step.NB,))
        assert_equal(tri[0], 0)
        assert_equal(tri[1], 0)
        assert_equal(tri[2], 1)
        assert_equal(tri[3], 3)
        assert_equal(tri[4], 4)
        assert_equal(tri[5], 3)
        assert_equal(tri[6], 5)
        assert_equal(tri[7], 5)

    def test_edge_map(self):
        bounds = np.asarray(self.edge_map.bounds)
        edges = np.asarray(self.edge_map.edges)
        location = np.asarray(self.edge_map.location)
        idx = np.asarray(self.edge_map.idx)

        assert_equal(bounds,
            [ 0 , 2 , 5 , 7 , 9 , 12 , 12 , 13 ])
        #     0   1   2   3   4   5    6    7      V0

        assert_equal(edges,
            [ 1 , 3 , 3 , 2 , 4 , 4 , 5 , 4 , 6 , 5 , 6 , 7 , 7 ])
        #   |       |           |       |       |           |   |
        #   0       1           2       3       4         5,6   7

        assert_equal(location,
            [ 1 , 1 , 0 , 1 , 0 , 0 , 1 , 0 , 1 , 1 , 0 , 1 , 1 ]
        #     0   0   1   1   1   2   2   3   3   4   4   4   6      V0
        #     1   3   3   2   4   4   5   4   6   5   6   7   7      V1
        #     0   1       2           3       4   5       6   7      idx in boundary_edges
        #             0       1   2       3           4              idx in intern_edges
        )

        assert_equal(idx,
            # see above : idx in boudnary_edges and idx in intern_edges.
            [ 0 , 1 , 0 , 2 , 1 , 2 , 3 , 3 , 4 , 5 , 4 , 6 , 7 ]
        )

class TestHole(unittest.TestCase):

    def setUp(self):
        self.intern_edges, self.boundary_edges, self.edge_map \
            = build_edges(hole.trivtx, hole.NV)

    def assert_intern_triangles(self, A, B, T, U):
        """Check that intern edge (A, B) has triangles (T, U)"""
        t, u = self.intern_edges[(A,B)]
        if (t, u) != (T, U):
            raise AssertionError(
                "Expected intern edge ({}, {}) to have triangles ({}, {}),"
                "but has triangles: ({}, {})" .format(T, U, t, u))

    def test_internal_edges(self):
        self.assertEqual(self.intern_edges.vertices.shape, (hole.NI, 2))
        self.assertEqual(self.intern_edges.triangles.shape, (hole.NI, 2))
        self.assert_intern_triangles( 9, 10,  8, 18)
        self.assert_intern_triangles(24, 30, 36, 37)
        self.assert_intern_triangles( 8, 15,  6, 23)

    def test_no_such_intern_edge(self):
        with self.assertRaisesRegex(KeyError, "No such intern edge"):
            self.intern_edges[(10, 18)]

    def assert_boundary_triangle(self, A, B, T):
        """Check that boundary edge (A, B) has triangles T"""
        t = self.boundary_edges[(A,B)]
        if t != T:
            raise AssertionError(
                "Expected boundary edge ({}, {}) to have triangle {},"
                "but has triangle: {}" .format(T, t))

    def test_boundary_edges(self):
        self.assertEqual(self.boundary_edges.vertices.shape, (hole.NB, 2))
        self.assertEqual(self.boundary_edges.triangles.shape, (hole.NB, ))
        self.assert_boundary_triangle( 2 , 3,  2)
        self.assert_boundary_triangle(18, 17, 25)
        self.assert_boundary_triangle(28, 21, 32)

if __name__ == '__main__':
    unittest.main()
