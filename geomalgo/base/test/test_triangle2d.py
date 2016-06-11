import unittest

from geomalgo import Point2D, Triangle2D

class TestTriangle(unittest.TestCase):
    """
      1 C
        | \
        |   \
        |     \
      0 A-------B
        0       1
    """

    def setUp(self):
        A = Point2D(0,0)
        B = Point2D(1,0)
        C = Point2D(0,1)

        self.triangle = Triangle2D(A, B, C)

    def assert_includes(self, x, y):
        P = Point2D(x,y)
        self.assertTrue( self.triangle.includes_point(P) )

    def assert_not_includes(self, x, y):
        P = Point2D(x,y)
        self.assertFalse( self.triangle.includes_point(P) )

    def test_includes_point(self):
        self.assert_includes(0.25, 0.25)

    def test_not_includes_point(self):
        self.assert_not_includes(1., 1.)

if __name__ == '__main__':
    unittest.main()

