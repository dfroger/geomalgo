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

        self.assertEqual(segment.u.x, 2)
        self.assertEqual(segment.u.y, 2)
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
        self.assertEqual(segment.u.x, 2)
        self.assertEqual(segment.u.y, 3)
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
        self.assertEqual(segment.u.x, -2)
        self.assertEqual(segment.u.y, -4)
        self.assertAlmostEqual(segment.length, 2*sqrt(5))

        M = segment.compute_middle()
        self.assertAlmostEqual(M.x, 0)
        self.assertAlmostEqual(M.y, 0)

    def test_from_tuple(self):
        segment = Segment2D((1, 2), (3, 4))
        self.assertEqual(segment.A.x, 1)
        self.assertEqual(segment.A.y, 2)

        self.assertEqual(segment.B.x, 3)
        self.assertEqual(segment.B.y, 4)

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

        xa = np.array([1, 1, 1], dtype='d')
        xb = np.array([2, 2, 2], dtype='d')

        ya = np.array([10, 11, 12], dtype='d')
        yb = np.array([10, 11, 12], dtype='d')

        collection = Segment2DCollection(xa, xb, ya, yb)
        CD = collection[1]

        self.assertEqual(CD.A.x,  1)
        self.assertEqual(CD.A.y, 11)

        self.assertEqual(CD.B.x,  2)
        self.assertEqual(CD.B.y, 11)

        self.assertAlmostEqual(CD.length, 1)


class TestPoint2dDistance(unittest.TestCase):

    def test_horizontal_line(self):
        """
              P

        A-----------B
        """

        A = Point2D(1, 2)
        B = Point2D(3, 2)
        AB = Segment2D(A, B)

        P = Point2D(2, 5)
        self.assertEqual(AB.point_distance(P), 3)

        P = Point2D(-3, 5)
        self.assertEqual(AB.point_distance(P), 5)

        P = Point2D(7, 5)
        self.assertEqual(AB.point_distance(P), 5)

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
        AB = Segment2D(A, B)

        P = Point2D(4, 3)
        self.assertEqual(AB.point_distance(P), 3)

        P = Point2D(4, -2)
        self.assertEqual(AB.point_distance(P), 5)

        P = Point2D(4, 8)
        self.assertEqual(AB.point_distance(P), 5)


    def test_on_horizontal_line(self):
        """
        A-----P-----B
        """

        A = Point2D(1, 2)
        B = Point2D(3, 2)
        AB = Segment2D(A, B)

        P = Point2D(2, 2)
        self.assertEqual(AB.point_distance(P), 0)

        P = Point2D(-3, 2)
        self.assertEqual(AB.point_distance(P), 4)

        P = Point2D(7, 2)
        self.assertEqual(AB.point_distance(P), 4)

    def test_on_vertical_line(self):
        """
        B
        |
        B
        |
        A
        """

        A = Point2D(1, 2)
        B = Point2D(1, 4)
        AB = Segment2D(A, B)

        P = Point2D(1, 3)
        self.assertEqual(AB.point_distance(P), 0)

        P = Point2D(1, -2)
        self.assertEqual(AB.point_distance(P), 4)

        P = Point2D(1, 8)
        self.assertEqual(AB.point_distance(P), 4)

if __name__ == '__main__':
    unittest.main()
