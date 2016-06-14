import unittest

import numpy as np

from geomalgo import Point2D, Polygon2D

class TestPolygon2D(unittest.TestCase):

    def test_create(self):
        """
        2  F----E
           |    |
        1  |    D----C
           |         |
        0  A---------B
           0    1    2
        """
        A = Point2D(0, 0)
        B = Point2D(2, 0)
        C = Point2D(2, 1)
        D = Point2D(1, 1)
        E = Point2D(1, 2)
        F = Point2D(0, 2)

        polygon2d = Polygon2D.from_points2d([A,B,C,D,E,F,A])

        np.testing.assert_equal(polygon2d.x, [0., 2., 2., 1., 1., 0., 0.])
        np.testing.assert_equal(polygon2d.y, [0., 0., 1., 1., 2., 2., 0.])

if __name__ == '__main__':
    unittest.main()
