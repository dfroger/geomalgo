import unittest

from geomalgo import Point

class TestPoint(unittest.TestCase):

    def test_property_x(self):
        A = Point(1,2,3)
        self.assertEqual(A.x, 1)
        A.x = 10
        self.assertEqual(A.x, 10)

    def test_vector_from_point_sub_point(self):
        A = Point(1,2,3)
        B = Point(6,5,4)
        V = B - A
        self.assertEqual(V.x, 5)
        self.assertEqual(V.y, 3)
        self.assertEqual(V.z, 1)

if __name__ == '__main__':
    unittest.main()
