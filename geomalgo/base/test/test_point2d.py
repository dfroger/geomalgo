import unittest

from geomalgo import Point2D, signed_double_area

class TestPoint2D(unittest.TestCase):

    def test_property_x(self):
        A = Point2D(1,2)
        self.assertEqual(A.x, 1)
        A.x = 10
        self.assertEqual(A.x, 10)

class TestSignedArea(unittest.TestCase):
    
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

        self.assertEqual(signed_double_area(A,B,C), 1.)
    
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

        self.assertEqual(signed_double_area(A,B,C), -1.)

if __name__ == '__main__':
    unittest.main()
