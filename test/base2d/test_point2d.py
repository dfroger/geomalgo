import unittest
from math import sqrt

from geomalgo import Point2D, is_left, is_counterclockwise, \
                     signed_triangle2d_area

class TestPoint2D(unittest.TestCase):

    def test_property_x(self):
        A = Point2D(1,2)
        self.assertEqual(A.x, 1)
        A.x = 10
        self.assertEqual(A.x, 10)

    def test_index(self):
        A = Point2D(1,2)
        self.assertEqual(A.index, 0)
        
        B = Point2D(1,2, index=8)
        self.assertEqual(B.index, 8)

    def test_distance(self):
        A = Point2D(2,1)
        B = Point2D(3,2)
        dist = A.distance(B)
        expected_dist = sqrt(2.)
        self.assertAlmostEqual(dist, expected_dist)

class TestIsLeft(unittest.TestCase):

    def test_is_left(self):
        """
        P

        A----B
        """
        A = Point2D(0,0)
        B = Point2D(1,0)
        P = Point2D(0,1)
        self.assertTrue(is_left(A,B,P))

    def test_is_right(self):
        """
        A----B

        P
        """
        A = Point2D(0,0)
        B = Point2D(1,0)
        P = Point2D(0,-1)
        self.assertFalse(is_left(A,B,P))

    def test_on_line(self):
        """
        A----B----P
        """
        A = Point2D(0,0)
        B = Point2D(1,0)
        P = Point2D(2,0)
        with self.assertRaisesRegex(ValueError, "Point P in on line \(AB\)"):
            is_left(A,B,P)

class TestIsCounterclockwise(unittest.TestCase):
    
    def test_counterclockwise(self):
        """
        C
        + 
        |  \
        |     \
        +--------+
        A        B
        """
        A = Point2D(0,0)
        B = Point2D(1,0)
        C = Point2D(0,1)
        self.assertTrue(is_counterclockwise(A,B,C))
    
    def test_clockwise(self):
        """
        B
        + 
        |  \
        |     \
        +--------+
        A        C
        """
        A = Point2D(0,0)
        B = Point2D(0,1)
        C = Point2D(1,0)
        self.assertFalse(is_counterclockwise(A,B,C))

    def test_on_line(self):
        """
        A----B----P
        """
        A = Point2D(0,0)
        B = Point2D(1,0)
        P = Point2D(2,0)
        msg = "Triangle is degenerated \(A, B and C are aligned\)"
        with self.assertRaisesRegex(ValueError, msg):
            is_counterclockwise(A,B,P)

class TestSignedTriangle2dArea(unittest.TestCase):
    
    def test_counterclockwise(self):
        """
        C
        + 
        |  \
        |     \
        +--------+
        A        B
        """
        A = Point2D(0,0)
        B = Point2D(1,0)
        C = Point2D(0,1)
        self.assertAlmostEqual(signed_triangle2d_area(A,B,C), 0.5)
    
    def test_clockwise(self):
        """
        B
        + 
        |  \
        |     \
        +--------+
        A        C
        """
        A = Point2D(0,0)
        B = Point2D(0,1)
        C = Point2D(1,0)
        self.assertAlmostEqual(signed_triangle2d_area(A,B,C), -0.5)

    def test_on_line(self):
        """
        A----B----P
        """
        A = Point2D(0,0)
        B = Point2D(1,0)
        C = Point2D(2,0)
        self.assertAlmostEqual(signed_triangle2d_area(A,B,C), 0.)

if __name__ == '__main__':
    unittest.main()
