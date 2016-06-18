import unittest

from geomalgo import Point3D, Segment3D

class TestTriangle(unittest.TestCase):

    def test_create_segment(self):
        A = Point3D(1,2,3)
        B = Point3D(6,5,3)

        segment = Segment3D(A,B)
        self.assertEqual(segment.B.y, 5)

        segment.B.y = 3
        self.assertEqual(segment.B.y, 3)

        segment.B = Point3D(-1, -2, -3)
        self.assertEqual(segment.B.y, -2)

if __name__ == '__main__':
    unittest.main()
