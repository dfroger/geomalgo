import unittest

from numpy.testing import assert_equal

from geomalgo import build_edges
from geomalgo.data import step

NV = 9

class TestEdges(unittest.TestCase):

    def setUp(self):
        self.intern_edges, self.boundary_edges = build_edges(step.trivtx, NV)

    def test_internal_edges_vertices (self):
        vert = self.intern_edges.vertices
        self.assertEqual(vert.shape, (5,2))
        assert_equal(vert[0], (1,3))
        assert_equal(vert[1], (1,4))
        assert_equal(vert[2], (2,4))
        assert_equal(vert[3], (3,4))
        assert_equal(vert[4], (4,6))

    def test_internal_edges_triangles (self):
        tri = self.intern_edges.triangles
        self.assertEqual(tri.shape, (5,2))
        assert_equal(tri[0], (0,2))
        assert_equal(tri[1], (2,1))
        assert_equal(tri[2], (1,3))
        assert_equal(tri[3], (4,2))
        assert_equal(tri[4], (4,5))

    def test_boundary_edges_vertices(self):
        vert = self.boundary_edges.vertices
        self.assertEqual(vert.shape, (8, 2))
        assert_equal(vert[0], (0,1))
        assert_equal(vert[1], (3,0))
        assert_equal(vert[2], (1,2))
        assert_equal(vert[3], (2,5))
        assert_equal(vert[4], (6,3))
        assert_equal(vert[5], (5,4))
        assert_equal(vert[6], (4,7))
        assert_equal(vert[7], (7,6))

    def test_boundary_edges_triangles(self):
        tri = self.boundary_edges.triangles
        self.assertEqual(tri.shape, (8,))
        assert_equal(tri[0], 0)
        assert_equal(tri[1], 0)
        assert_equal(tri[2], 1)
        assert_equal(tri[3], 3)
        assert_equal(tri[4], 4)
        assert_equal(tri[5], 3)
        assert_equal(tri[6], 5)
        assert_equal(tri[7], 5)

if __name__ == '__main__':
    unittest.main()
