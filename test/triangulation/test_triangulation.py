import unittest

from numpy.testing import assert_allclose

from geomalgo import Triangulation2D
from geomalgo.data import step

class TestTriangulation(unittest.TestCase):

    def setUp(self):
        self.TG = Triangulation2D(step.x, step.y, step.trivtx)

    def test_get(self):

        triangle = self.TG[3]

        self.assertEqual(triangle.index, 3)

        self.assertEqual(triangle.A.x, 2.5)
        self.assertEqual(triangle.A.y,  10)

        self.assertEqual(triangle.B.x, 2.5)
        self.assertEqual(triangle.B.y,  11)

        self.assertEqual(triangle.C.x, 1)
        self.assertEqual(triangle.C.y, 11)

        self.assertAlmostEqual(triangle.area, 0.75)

    def test_centers(self):
        TG = self.TG

        self.assertIsNone(TG.xcenter)
        self.assertIsNone(TG.ycenter)

        TG.compute_centers()

        a = 1/3
        b = 2/3
        assert_allclose(TG.xcenter, [a, 1.5, b, 2, a, b])
        assert_allclose(TG.ycenter, [10+a, 10+a, 10+b, 10+b, 11+a, 11+b])

if __name__ == '__main__':
    unittest.main()
