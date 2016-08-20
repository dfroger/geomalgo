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

    def test_add_vector(self):
        A = Vector2D(1,2)
        B = Vector2D(4,6)
        V = A + B
        self.assertEqual(V.x, 5)
        self.assertEqual(V.y, 8)

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

class TestNormal(unittest.TestCase):

    def test_horizontal(self):
        """
        vec
        ---------->  |
                     | normal
                     v
        """
        V = Vector2D(3, 0)
        N = V.normal
        self.assertAlmostEqual(N.x, 0)
        self.assertAlmostEqual(N.y, -1)

    def test_horizontal_negative(self):
        """
        ^ normal
        |          vec
        |  <----------
        """
        V = Vector2D(-0.2, 0)
        N = V.normal
        self.assertAlmostEqual(N.x, 0)
        self.assertAlmostEqual(N.y, 1)

    def test_vertical(self):
        """
        ^ vec
        |         normal
        |  --------->
        """
        V = Vector2D(0, 0.2)
        N = V.normal
        self.assertAlmostEqual(N.x, 1)
        self.assertAlmostEqual(N.y, 0)

    def test_vertical_negative(self):
        """
        normal
        <---------  |
                    | vec
                    v
        """
        V = Vector2D(0, -0.2)
        N = V.normal
        self.assertAlmostEqual(N.x, -1)
        self.assertAlmostEqual(N.y,  0)

    def test_oblique(self):
        """
                   _
                   /| vec
                /
            / \
        /      \
               _\| normal
        """
        V = Vector2D(3, 4)
        N = V.normal
        self.assertAlmostEqual(N.x,  0.8)
        self.assertAlmostEqual(N.y, -0.6)


if __name__ == '__main__':
    unittest.main()
