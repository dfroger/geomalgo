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

        # CASE12
        P,Q = Point2D(0, 3), Point2D(3, 3)
        R,S = Point2D(2, 0), Point2D(2, 4)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertAlmostEqual(I0.x, 2.)
        self.assertAlmostEqual(I0.y, 3.)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 2)
        self.assertAlmostEqual(coords[0], 2./3.)
        self.assertAlmostEqual(coords[1], 3./4.)

    def test_parallel(self):
        """
        4         
                  
        3  P--------Q
                  
        1  R--------S
                  
        0         
           0  1  2  3

        """

        #CASE00
        P,Q = Point2D(0, 3), Point2D(3, 3)
        R,S = Point2D(0, 1), Point2D(3, 1)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertIsNone(I0)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 0)

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

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertAlmostEqual(I0.x, P.x)
        self.assertAlmostEqual(I0.y, P.y)

        self.assertAlmostEqual(I1.x, Q.x)
        self.assertAlmostEqual(I1.y, Q.y)

        self.assertEqual(len(coords), 4)
        self.assertAlmostEqual(coords[0], 0)
        self.assertAlmostEqual(coords[1], 0)
        self.assertAlmostEqual(coords[2], 1)
        self.assertAlmostEqual(coords[3], 1)

    def test_colinear_no_overlap(self):
        """
                  
        3  P-----Q     R-----S
                                    
           0     1     2     3
        """

        # CASE07
        P,Q = Point2D(0, 3), Point2D(1, 3)
        R,S = Point2D(2, 3), Point2D(3, 3)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertIsNone(I0)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 0)

    def test_colinear_intersect_one_point(self):
        """
                Q R
        3  P-----+-----S
                                    
           0     1     2
        """

        # CASE08
        P,Q = Point2D(0, 3), Point2D(1, 3)
        R,S = Point2D(1, 3), Point2D(2, 3)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertAlmostEqual(I0.x, 1)
        self.assertAlmostEqual(I0.y, 3)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 2)
        self.assertAlmostEqual(coords[0], 1)
        self.assertAlmostEqual(coords[1], 0)

    def test_colinear_overlap_segment(self):
        """
        3  P-----+-----Q-----+
                 R           S      
           0   1   2   3
        """

        # CASE09
        P,Q = Point2D(0,   3), Point2D(3, 3)
        R,S = Point2D(1.5, 3), Point2D(4.5, 3)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertAlmostEqual(I0.x, R.x)
        self.assertAlmostEqual(I0.y, R.y)

        self.assertAlmostEqual(I1.x, Q.x)
        self.assertAlmostEqual(I1.y, Q.y)

        self.assertEqual(len(coords), 4)
        self.assertAlmostEqual(coords[0], 0.5)
        self.assertAlmostEqual(coords[1], 0)
        self.assertAlmostEqual(coords[2], 1)
        self.assertAlmostEqual(coords[3], 0.5)

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

        # CASE10
        P,Q = Point2D(0, 3), Point2D(3, 3)
        R,S = Point2D(4, 0), Point2D(4, 4)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertIsNone(I0)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 0)

        # CASE11
        I0, I1, coords = RS.intersect_segment(PQ, return_coords=True)

        self.assertIsNone(I0)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 0)

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

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertAlmostEqual(I0.x, 3.)
        self.assertAlmostEqual(I0.y, 3.)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 2)
        self.assertAlmostEqual(coords[0], 1)
        self.assertAlmostEqual(coords[1], 1)

    def test_same_point(self):
        """
            P Q
          1  +
            R S
             1
        """

        # CASE02
        P,Q = Point2D(1, 1), Point2D(1, 1)
        R,S = Point2D(1, 1), Point2D(1, 1)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertAlmostEqual(I0.x, 1)
        self.assertAlmostEqual(I0.y, 1)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 2)
        self.assertAlmostEqual(coords[0], 0)
        self.assertAlmostEqual(coords[1], 0)

    def test_distinct_point(self):
        """
            P Q     R S
           1 +       +
             1       2
        """

        # CASE01
        P,Q = Point2D(1, 1), Point2D(1, 1)
        R,S = Point2D(1, 2), Point2D(1, 2)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertIsNone(I0)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 0)

    def test_collinear_point_not_in_segment(self):
        """
             P Q          
           1  +   R-----S 
              1   2     3
        """

        # CASE03
        P,Q = Point2D(1, 1), Point2D(1, 1)
        R,S = Point2D(1, 2), Point2D(1, 3)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertIsNone(I0)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 0)

        # CASE05
        I0, I1, coords = RS.intersect_segment(PQ, return_coords=True)

        self.assertIsNone(I0)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 0)

    def test_collinear_point_in_segment(self):
        """
               P Q          
           1 R--+--S 
             1  2  3
        """

        # CASE04
        P,Q = Point2D(2, 1), Point2D(2, 1)
        R,S = Point2D(1, 1), Point2D(3, 1)

        PQ = Segment2D(P, Q)
        RS = Segment2D(R, S)

        I0, I1, coords = PQ.intersect_segment(RS, return_coords=True)

        self.assertAlmostEqual(I0.x, 2)
        self.assertAlmostEqual(I0.y, 1)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 2)
        self.assertAlmostEqual(coords[0], 0)
        self.assertAlmostEqual(coords[1], 0.5)

        # CASE06
        I0, I1, coords = RS.intersect_segment(PQ, return_coords=True)

        self.assertAlmostEqual(I0.x, 2)
        self.assertAlmostEqual(I0.y, 1)
        self.assertIsNone(I1)

        self.assertEqual(len(coords), 2)
        self.assertAlmostEqual(coords[0], 0.5)
        self.assertAlmostEqual(coords[1], 0)

if __name__ == '__main__':
    unittest.main()
