import unittest

from geomalgo import Point2D, Segment2D

class TestSegment2D(unittest.TestCase):

    def test_create_segment(self):
        A = Point2D(1,2)
        B = Point2D(3,4)

        segment = Segment2D(A,B)
        self.assertEqual(segment.B.y, 4)

        segment.B.y = 5
        self.assertEqual(segment.B.y, 5)

        segment.B = Point2D(-1, -2)
        self.assertEqual(segment.B.y, -2)

    def test_horizontal_segment_includes_point(self):
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

        self.assertTrue( segment.includes_point(I) )

        self.assertTrue( segment.includes_point(A) )
        self.assertTrue( segment.includes_point(B) )

        self.assertFalse( segment.includes_point(O) )
        self.assertFalse( segment.includes_point(P) )

    def test_vertical_segment_includes_point(self):
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

        self.assertTrue( segment.includes_point(I) )

        self.assertTrue( segment.includes_point(A) )
        self.assertTrue( segment.includes_point(B) )

        self.assertFalse( segment.includes_point(O) )
        self.assertFalse( segment.includes_point(P) )

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

if __name__ == '__main__':
    unittest.main()
