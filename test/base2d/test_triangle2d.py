import unittest

import numpy as np

from geomalgo import Point2D, Triangle2D


class TestTriangle2D(unittest.TestCase):
    """
      1 C
        | \
        |   \
        |     \
      0 A-------B
        0       1
    """

    def test_create(self):
        A = Point2D(0,0)
        B = Point2D(1,0)
        C = Point2D(0,1)

        triangle = Triangle2D(A, B, C, index=4)
        self.assertAlmostEqual(triangle.area, 0.5)

        # Change coordiante, and recompute
        triangle.A.y = -1
        triangle.recompute()
        self.assertAlmostEqual(triangle.area, 1)

        # Change point, and recompute
        triangle.A = Point2D(0,0)
        triangle.recompute()
        self.assertAlmostEqual(triangle.area, 0.5)

    def test_degenerated(self):
        """
        A----B----P
        """
        A = Point2D(0,0)
        B = Point2D(1,0)
        C = Point2D(2,0)

        with self.assertRaisesRegex(ValueError, "Triangle is degenerated"):
            triangle = Triangle2D(A, B, C)


class TestAreaAndCounterclockwise(unittest.TestCase):

    def test_counterclockwise(self):
        """
        C
        +
        |  \
        |     \
        +--------+
        A        B
        """
        A = Point2D(0,0)
        B = Point2D(1,0)
        C = Point2D(0,1)

        triangle = Triangle2D(A, B, C)

        self.assertAlmostEqual(triangle.signed_area, 0.5)
        self.assertAlmostEqual(triangle.area, 0.5)
        self.assertTrue(triangle.counterclockwise)

        triangle = Triangle2D(A, B, C, force_counterclockwise=True)

        self.assertAlmostEqual(triangle.signed_area, 0.5)
        self.assertAlmostEqual(triangle.area, 0.5)
        self.assertTrue(triangle.counterclockwise)

    def test_clockwise(self):
        """
        B
        +
        |  \
        |     \
        +--------+
        A        C
        """
        A = Point2D(0,0)
        B = Point2D(0,1)
        C = Point2D(1,0)

        triangle = Triangle2D(A, B, C)

        self.assertAlmostEqual(triangle.signed_area, -0.5)
        self.assertAlmostEqual(triangle.area, 0.5)
        self.assertFalse(triangle.counterclockwise)

        triangle = Triangle2D(A, B, C, force_counterclockwise=True)

        self.assertAlmostEqual(triangle.signed_area, 0.5)
        self.assertAlmostEqual(triangle.area, 0.5)
        self.assertTrue(triangle.counterclockwise)


class TestCenter(unittest.TestCase):

    def test_normal(self):

        A = Point2D(0,0)
        B = Point2D(3,0)
        C = Point2D(0,6)

        triangle = Triangle2D(A, B, C)

        C = triangle.center

        self.assertAlmostEqual(C.x, 1.)
        self.assertAlmostEqual(C.y, 2.)


class TestInterpolate(unittest.TestCase):

    def f(self, x, y):
        return 3*x - 4*y + 1

    def check_interpolate_at(self, x, y):
        P = Point2D(x, y)
        actual = self.triangle.interpolate(self.data, P)
        expected = self.f(x, y)
        self.assertAlmostEqual(actual, expected)

    def test_normal(self):
        """
          C
        1 +
          |  \
          |     \
        0 +--------+
          A        B
          0        1
        """

        A = Point2D(0, 0)
        B = Point2D(1, 0)
        C = Point2D(0, 1)
        self.triangle = Triangle2D(A, B, C)

        x = np.array( [A.x, B.x, C.x] )
        y = np.array( [A.y, B.y, C.y] )
        self.data = self.f(x, y)

        self.check_interpolate_at(A.x, A.y)
        self.check_interpolate_at(B.x, B.y)
        self.check_interpolate_at(C.x, C.y)
        self.check_interpolate_at(0.25, 0.25)
        self.check_interpolate_at(0.1, 0.2)
        self.check_interpolate_at(0.2, 0.1)

    def test_clockwise(self):

        """
          C
        1 +
          |  \
          |     \
        0 +--------+
          A        B
          0        1
        """

        A = Point2D(0, 0)
        C = Point2D(1, 0)
        B = Point2D(0, 1)
        self.triangle = Triangle2D(A, B, C)

        x = np.array( [A.x, B.x, C.x] )
        y = np.array( [A.y, B.y, C.y] )
        self.data = self.f(x, y)

        self.check_interpolate_at(A.x, A.y)
        self.check_interpolate_at(B.x, B.y)
        self.check_interpolate_at(C.x, C.y)
        self.check_interpolate_at(0.25, 0.25)
        self.check_interpolate_at(0.1, 0.2)
        self.check_interpolate_at(0.2, 0.1)

if __name__ == '__main__':
    unittest.main()
