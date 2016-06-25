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

        self.assertTrue( segment.includes_point(I) )

        self.assertTrue( segment.includes_point(A) )
        self.assertTrue( segment.includes_point(B) )

        self.assertFalse( segment.includes_point(O) )
        self.assertFalse( segment.includes_point(P) )

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

        self.assertTrue( segment.includes_point(I) )

        self.assertTrue( segment.includes_point(A) )
        self.assertTrue( segment.includes_point(B) )

        self.assertFalse( segment.includes_point(O) )
        self.assertFalse( segment.includes_point(P) )

if __name__ == '__main__':
    unittest.main()
