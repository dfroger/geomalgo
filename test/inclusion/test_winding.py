import unittest

from geomalgo import Point2D, Polygon2D, Triangle2D, Segment2D

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


class TriangleWinding(unittest.TestCase):

    """
    Base class for Polygon2D and Triange2D.

    Triangle2D use the same algorithm that Polygon2d, but specialized
    for optimization.

    """

    def assert_inside(self, A, B, C, P, edge_width=0.):
        triangle = Triangle2D(A, B, C)
        #polygon = Polygon2D.from_points2d([A,B,C])

        self.assertTrue(triangle.includes_point(P, edge_width=edge_width))
        #self.assertTrue(polygon.includes_point(P) )

    def assert_outside(self, A, B, C, P):
        triangle = Triangle2D(A, B, C)
        polygon = Polygon2D.from_points2d([A,B,C])

        self.assertFalse(triangle.includes_point(P))
        self.assertFalse(polygon.includes_point(P) )

    def test_inside(self):
        A = Point2D(0, 0)
        B = Point2D(1, 0)
        C = Point2D(0, 1)
        P = Point2D(0.25, 0.25)
        self.assert_inside(A, B, C, P)

    def test_outside(self):
        A = Point2D(0, 0)
        B = Point2D(1, 0)
        C = Point2D(0, 1)
        P = Point2D(1., 1.)
        self.assert_outside(A, B, C, P)

    def test_inside_on_edge(self):
        # Example taken from:
        # https://totologic.blogspot.fr/2014/01/accurate-point-in-triangle-test.html
        A = Point2D(1/10, 1/9)
        B = Point2D(100/8, 100/3)
        C = Point2D(100/4, 100/9)
        D = Point2D(-100/8, 100/6)
        AB = Segment2D(A, C)
        P = A + (B-A)*(3/7)
        self.assert_inside(A, B, C, P, edge_width=1.E-03)

if __name__ == '__main__':
    unittest.main()
