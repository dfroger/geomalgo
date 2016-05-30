import unittest

from geomalgo import Point2D, Polygon2D

class TestWinding(unittest.TestCase):

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
        self.assertTrue(self.polygon2d.point_is_inside(P))

    def test_point_is_outside(self):
        P = Point2D(1.5, 0.5)
        self.assertFalse(self.polygon2d.point_is_inside(P))

if __name__ == '__main__':
    unittest.main()
