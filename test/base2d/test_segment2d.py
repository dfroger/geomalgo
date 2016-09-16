import unittest
from math import sqrt

import numpy as np

from geomalgo import Point2D, Segment2D, Segment2DCollection

class TestSegment2D(unittest.TestCase):

    def test_create_segment(self):
        A = Point2D(1,2)
        B = Point2D(3,4)

        # ======================
        # Create segment2d.
        # ======================
        segment = Segment2D(A,B)
        self.assertEqual(segment.B.y, 4)

        self.assertEqual(segment.AB.x, 2)
        self.assertEqual(segment.AB.y, 2)
        self.assertAlmostEqual(segment.length, 2*sqrt(2))

        M = segment.compute_middle()
        self.assertAlmostEqual(M.x, 2)
        self.assertAlmostEqual(M.y, 3)

        # ======================
        # Modify B.y
        # ======================
        segment.B.y = 5
        self.assertEqual(segment.B.y, 5)

        segment.recompute()
        self.assertEqual(segment.AB.x, 2)
        self.assertEqual(segment.AB.y, 3)
        self.assertAlmostEqual(segment.length, sqrt(13))

        M = segment.compute_middle()
        self.assertAlmostEqual(M.x, 2)
        self.assertAlmostEqual(M.y, 3.5)

        # ======================
        # Modify B
        # ======================
        segment.B = Point2D(-1, -2)
        self.assertEqual(segment.B.y, -2)

        segment.recompute()
        self.assertEqual(segment.AB.x, -2)
        self.assertEqual(segment.AB.y, -4)
        self.assertAlmostEqual(segment.length, 2*sqrt(5))

        M = segment.compute_middle()
        self.assertAlmostEqual(M.x, 0)
        self.assertAlmostEqual(M.y, 0)

class TestIncludesPoint(unittest.TestCase):

    def test_horizontal_segment(self):
        """

        O      A      I      B      P
        +------+------+------+------+
        -0.5   0      0.5    1      1.5
        """

        A = Point2D(0, 0)
        B = Point2D(1, 0)
        segment = Segment2D(A,B)

        O = Point2D(-0.5, 0)
        I = Point2D( 0.5, 0)
        P = Point2D( 1.5, 0)

        self.assertTrue( segment.includes_collinear_point(I) )

        self.assertTrue( segment.includes_collinear_point(A) )
        self.assertTrue( segment.includes_collinear_point(B) )

        self.assertFalse( segment.includes_collinear_point(O) )
        self.assertFalse( segment.includes_collinear_point(P) )

    def test_vertical_segment(self):
        """
         1.5  + P
              |
         1    + B
              |
         0.5  + I
              |
         0    + A
              |
        -0.5  + 0
        """

        A = Point2D(0, 0)
        B = Point2D(0, 1)
        segment = Segment2D(A,B)

        O = Point2D(0, -0.5)
        I = Point2D(0,  0.5)
        P = Point2D(0,  1.5)

        self.assertTrue( segment.includes_collinear_point(I) )

        self.assertTrue( segment.includes_collinear_point(A) )
        self.assertTrue( segment.includes_collinear_point(B) )

        self.assertFalse( segment.includes_collinear_point(O) )
        self.assertFalse( segment.includes_collinear_point(P) )


class TestSegment2DAt(unittest.TestCase):

    def test_horizontal_segment(self):
        """
        A-----P-----+-----+-----B
        0     0.5   1     1.5   2.
        """

        A = Point2D(0, 3)
        B = Point2D(2, 3)
        segment = Segment2D(A, B)

        P = segment.at(0.25)

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

        P = segment.at(0.25)

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

        P = segment.at(0.25)

        self.assertAlmostEqual(P.x, 6)
        self.assertAlmostEqual(P.y, 0.5)

class TestSegment2DWhere(unittest.TestCase):

    def test_horizontal_segment(self):
        """
        A-----P-----+-----+-----B
        0     0.5   1     1.5   2.
        """

        A = Point2D(0, 3)
        B = Point2D(2, 3)
        P = Point2D(0.5, 3)
        segment = Segment2D(A, B)

        coord = segment.where(P)

        self.assertAlmostEqual(coord, 0.25)

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
        P = Point2D(3, 0.5)
        segment = Segment2D(A, B)

        coord = segment.where(P)

        self.assertAlmostEqual(coord, 0.25)

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
        P = Point2D(6, 0.25)
        segment = Segment2D(A, B)

        coord = segment.where(P)

        self.assertAlmostEqual(coord, 0.25)

class TestSegment2DCollection(unittest.TestCase):

    def test_get(self):
        """
        12  E------F

        11  C------D

        10  A------B
            1      2
        """

        x = np.array([
            [1, 2], # AB
            [1, 2], # CD
            [1, 2], # EF
        ], dtype='d')

        y = np.array([
            [10, 10], # AB
            [11, 11], # CD
            [12, 12], # EF
        ], dtype='d')

        collection = Segment2DCollection(x, y)
        CD = collection[1]

        self.assertEqual(CD.A.x,  1)
        self.assertEqual(CD.A.y, 11)

        self.assertEqual(CD.B.x,  2)
        self.assertEqual(CD.B.y, 11)

        self.assertAlmostEqual(CD.length, 1)

if __name__ == '__main__':
    unittest.main()
