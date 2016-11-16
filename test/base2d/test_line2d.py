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


if __name__ == '__main__':
    unittest.main()
