import unittest
from math import sqrt

from geomalgo import Vector2D

class TestVector(unittest.TestCase):

    def test_dot_product(self):
        A = Vector2D(1,-2)
        B = Vector2D(3,4)
        x = A.dot(B)
        self.assertEqual(x, -5)

    def test_norm(self):
        A = Vector2D(1, 0)
        self.assertEqual(A.norm, 1.)

        A = Vector2D(1, 2)
        self.assertAlmostEqual(A.norm, sqrt(5.))

    def test_subtract_vector(self):
        A = Vector2D(1,2)
        B = Vector2D(4,6)
        V = B - A
        self.assertEqual(V.x, 3)
        self.assertEqual(V.y, 4)

    def test_cross_product(self):
        A = Vector2D(1,-2)
        B = Vector2D(3,4)
        x = A * B
        self.assertEqual(x, 10)

    def test_normalize(self):
        A = Vector2D(3, 4)
        A.normalize()
        self.assertAlmostEqual(A.x, 0.6)
        self.assertAlmostEqual(A.y, 0.8)
        self.assertAlmostEqual(A.norm, 1.)
        

if __name__ == '__main__':
    unittest.main()
