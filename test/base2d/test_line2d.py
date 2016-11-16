import unittest
from math import sqrt

import numpy as np

from geomalgo import Point2D, Line2D

class TestLine2D(unittest.TestCase):

    def test_create_line(self):
        A = Point2D(1,2)
        B = Point2D(3,4)

        # ======================
        # Create line2d.
        # ======================
        line = Line2D(A,B)
        self.assertEqual(line.B.y, 4)

        # ======================
        # Modify B.y
        # ======================
        line.B.y = 5
        self.assertEqual(line.B.y, 5)

        # ======================
        # Modify B
        # ======================
        line.B = Point2D(-1, -2)
        self.assertEqual(line.B.y, -2)


class TestPoint2dDistance(unittest.TestCase):

    def test_horizontal_line(self):
        """
              P

        A-----------B
        """

        A = Point2D(1, 2)
        B = Point2D(3, 2)
        AB = Line2D(A, B)

        P = Point2D(2, 4)
        self.assertEqual(AB.point_distance(P), 2)

        P = Point2D(10, 4)
        self.assertEqual(AB.point_distance(P), 2)

    def test_vertical_line(self):
        """
        B
        |
        |  B
        |
        A
        """

        A = Point2D(1, 2)
        B = Point2D(1, 4)
        AB = Line2D(A, B)

        P = Point2D(3, 3)
        self.assertEqual(AB.point_distance(P), 2)

        P = Point2D(3, 10)
        self.assertEqual(AB.point_distance(P), 2)


    def test_on_horizontal_line(self):
        """
        A-----P-----B
        """

        A = Point2D(1, 2)
        B = Point2D(3, 2)
        AB = Line2D(A, B)

        P = Point2D(2, 2)
        self.assertEqual(AB.point_distance(P), 0)

        P = Point2D(10, 2)
        self.assertEqual(AB.point_distance(P), 0)


if __name__ == '__main__':
    unittest.main()
