import unittest
from math import sqrt, pi

from geomalgo import Point2D, is_left, is_counterclockwise

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

    def test_vector_from_point_sub_point(self):
        A = Point2D(1,2)
        B = Point2D(4,3)
        V = B - A
        self.assertEqual(V.x, 3)
        self.assertEqual(V.y, 1)

    def test_str(self):
        A = Point2D(2,1)
        expected_string = "Point2D(2.0, 1.0)"
        string = str(A)
        self.assertEqual(string, expected_string)

    def test_to_polar(self):
        A = Point2D(2, 0)
        P = A.to_polar()
        self.assertAlmostEqual(P.r, 2)
        self.assertAlmostEqual(P.theta, 0)

        A = Point2D(0, 2)
        P = A.to_polar()
        self.assertAlmostEqual(P.r, 2.)
        self.assertAlmostEqual(P.theta, pi/2)

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

class TestEquality(unittest.TestCase):

    def test_equal(self):
        A = Point2D(2, 1)
        B = Point2D(2, 1)
        self.assertEqual(A, B)

    def test_not_equal(self):
        A = Point2D(1, 1)
        B = Point2D(2, 1)
        C = Point2D(1, 2)
        self.assertNotEqual(A, B)
        self.assertNotEqual(A, C)


if __name__ == '__main__':
    unittest.main()
