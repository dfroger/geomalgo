import unittest

from geomalgo import Point2D, Polygon2D, Triangle2D

class TestSquareWinding(unittest.TestCase):

    """
    1  D-------C
       |       |
       |       |
       |       |
    0  A-------B
       0        1
    """

    A = Point2D(0, 0)
    B = Point2D(1, 0)
    C = Point2D(1, 1)
    D = Point2D(0, 1)

    polygon2d = Polygon2D.from_points2d([A,B,C,D])

    def test_point_is_inside(self):
        P = Point2D(0.5, 0.5)
        self.assertTrue(self.polygon2d.includes_point(P))

    def test_point_is_outside(self):
        P = Point2D(1.5, 0.5)
        self.assertFalse(self.polygon2d.includes_point(P))

class TriangleWindingBase:

    """
    Base class for Polygon2D and Triange2D.

    Triangle2D use the same algorithm that Polygon2d, but specialized
    for optimization.

    Derived class must implement the `build` method to create the `obj`
    attribute, either a Triangle2D instance or a Polygon2D instance.

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

        self.build(A, B, C)

    def assert_inside(self, x, y):
        P = Point2D(x,y)
        self.assertTrue( self.obj.includes_point(P) )

    def assert_outside(self, x, y):
        P = Point2D(x,y)
        self.assertFalse( self.obj.includes_point(P) )

    def test_inside(self):
        self.assert_inside(0.25, 0.25)

    def test_outside(self):
        self.assert_outside(1., 1.)

@unittest.skip
class TestTriangle2DWinding(TriangleWindingBase, unittest.TestCase):

    def build(self, A, B, C):
        self.obj = Triangle2D(A, B, C)

class TestPolygon2DWinding(TriangleWindingBase, unittest.TestCase):

    def build(self, A, B, C):
        self.obj = Polygon2D.from_points2d([A,B,C])

if __name__ == '__main__':
    unittest.main()
