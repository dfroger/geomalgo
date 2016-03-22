import unittest

from geomalgo import Point, Segment

class TestTriangle(unittest.TestCase):

    def test_create_segment(self):
        A = Point(1,2,3)
        B = Point(6,5,3)

        segment = Segment(A,B)
        self.assertEqual(segment.B.y, 5)

        segment.B.y = 3
        self.assertEqual(segment.B.y, 3)

        segment.B = Point(-1, -2, -3)
        self.assertEqual(segment.B.y, -2)

if __name__ == '__main__':
    unittest.main()
