import unittest

from geomalgo import Triangulation2D
from geomalgo.data import step

class TestTriangulation(unittest.TestCase):

    def test_get(self):
        triangulation = Triangulation2D(step.x, step.y, step.trivtx)

        triangle = triangulation[3]

        self.assertEqual(triangle.index, 3)

        self.assertEqual(triangle.A.x, 2.5)
        self.assertEqual(triangle.A.y,  10)

        self.assertEqual(triangle.B.x, 2.5)
        self.assertEqual(triangle.B.y,  11)

        self.assertEqual(triangle.C.x, 1)
        self.assertEqual(triangle.C.y, 11)

        self.assertAlmostEqual(triangle.area, 0.75)

if __name__ == '__main__':
    unittest.main()
