import unittest

from geomalgo import Point2D, Segment2D

class TestTriangle(unittest.TestCase):

    def test_create_segment(self):
        A = Point2D(1,2)
        B = Point2D(3,4)

        segment = Segment2D(A,B)
        self.assertEqual(segment.B.y, 4)

        segment.B.y = 5
        self.assertEqual(segment.B.y, 5)

        segment.B = Point2D(-1, -2)
        self.assertEqual(segment.B.y, -2)

if __name__ == '__main__':
    unittest.main()
