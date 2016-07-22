import unittest

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

class TestArea(unittest.TestCase):

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

    def test_on_line(self):
        """
        A----B----P
        """
        A = Point2D(0,0)
        B = Point2D(1,0)
        C = Point2D(2,0)

        triangle = Triangle2D(A, B, C)

        self.assertAlmostEqual(triangle.signed_area, 0.)
        self.assertAlmostEqual(triangle.area, 0.)

class TestCenter(unittest.TestCase):

    def test_normal(self):

        A = Point2D(0,0)
        B = Point2D(3,0)
        C = Point2D(0,6)

        triangle = Triangle2D(A, B, C)

        C = triangle.center

        self.assertAlmostEqual(C.x, 1.)
        self.assertAlmostEqual(C.y, 2.)

if __name__ == '__main__':
    unittest.main()
