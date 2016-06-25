import unittest

from geomalgo import Point2D, Segment2D

class TestParametricCoord1D(unittest.TestCase):

    def test_horizontal_segment(self):
        """
        A-----P-----+-----+-----B
        0     0.5   1     1.5   2.
        """

        A = Point2D(0, 3)
        B = Point2D(2, 3)
        segment = Segment2D(A, B)

        P = segment.at_parametric_coord(0.25)

        self.assertAlmostEqual(P.x, 0.5)
        self.assertAlmostEqual(P.y, 3)

    def test_vertical_segment(self):
        """
          2  B
             |
        1.5  +
             |
          1  +
             |
        0.5  P
             |
          0  A
        """

        A = Point2D(3, 0)
        B = Point2D(3, 2)
        segment = Segment2D(A, B)

        P = segment.at_parametric_coord(0.25)

        self.assertAlmostEqual(P.x, 3)
        self.assertAlmostEqual(P.y, 0.5)

    def test_diagonal_segment(self):
        """
            2                  B
          1.5              +
            1          +
          0.5      P
            0  A
               4   6   8   10  12
        """

        A = Point2D( 4, 0)
        B = Point2D(12, 2)
        segment = Segment2D(A, B)

        P = segment.at_parametric_coord(0.25)

        self.assertAlmostEqual(P.x, 6)
        self.assertAlmostEqual(P.y, 0.5)

if __name__ == '__main__':
    unittest.main()
