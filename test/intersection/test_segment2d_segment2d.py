import unittest

from geomalgo import Point2D, Segment2D

class TestSegment(unittest.TestCase):

    def test_intersection(self):
        """
        4        S
                 |
        3  P-----I--Q
                 |
        1        |
                 |
        0        R
           0  1  2  3
        """

        P,Q = Point2D(0, 3), Point2D(3, 3)
        R,S = Point2D(2, 0), Point2D(2, 4)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        intersection = PQ.intersect_segment(RS)

        self.assertIsInstance(intersection, Point2D)
        self.assertAlmostEqual(intersection.x, 2.)
        self.assertAlmostEqual(intersection.y, 3.)

    def test_parallel(self):
        """
        4         
                  
        3  P--------Q
                  
        1  R--------S
                  
        0         
           0  1  2  3
        """

        P,Q = Point2D(0, 3), Point2D(3, 3)
        R,S = Point2D(0, 1), Point2D(3, 1)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        intersection = PQ.intersect_segment(RS)
        self.assertIsNone(intersection)

    def test_equal(self):
        """
        4         
                  
        3  P--------Q
           R        S      
        1            
                  
        0         
           0  1  2  3
        """

        P,Q = Point2D(0, 3), Point2D(3, 3)
        R,S = Point2D(0, 3), Point2D(3, 3)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        intersection = PQ.intersect_segment(RS)

        self.assertIsInstance(intersection, Segment2D)
        
        self.assertAlmostEqual(intersection.A.x, P.x)
        self.assertAlmostEqual(intersection.A.y, P.y)

        self.assertAlmostEqual(intersection.B.x, Q.x)
        self.assertAlmostEqual(intersection.B.y, Q.y)

    def test_colinear(self):
        """
        4         
                  
        3  P-----+-----Q-----+
                 R           S      
        1            
                  
        0         
           0   1   2   3
        """

        P,Q = Point2D(0,   3), Point2D(3, 3)
        R,S = Point2D(1.5, 3), Point2D(4.5, 3)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        intersection = PQ.intersect_segment(RS)

        self.assertIsInstance(intersection, Segment2D)
        
        self.assertAlmostEqual(intersection.A.x, R.x)
        self.assertAlmostEqual(intersection.A.y, R.y)

        self.assertAlmostEqual(intersection.B.x, Q.x)
        self.assertAlmostEqual(intersection.B.y, Q.y)

    def test_no_intersection(self):
        """
        4              S
                       |
        3  P--------Q  |
                       |
        1              |
                       |
        0              R
           0  1  2  3  4
        """

        P,Q = Point2D(0, 3), Point2D(3, 3)
        R,S = Point2D(4, 0), Point2D(4, 4)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        intersection = PQ.intersect_segment(RS)
        self.assertIsNone(intersection)

    def test_extremity(self):
        """
        4         
                    S
        3  P--------Q
                    |
        1           |
                    |
        0           R
           0  1  2  3
        """

        P,Q = Point2D(0, 3), Point2D(3, 3)
        R,S = Point2D(3, 0), Point2D(3, 3)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        intersection = PQ.intersect_segment(RS)
        self.assertIsInstance(intersection, Point2D)

        self.assertAlmostEqual(intersection.x, 3.)
        self.assertAlmostEqual(intersection.y, 3.)

if __name__ == '__main__':
    unittest.main()
