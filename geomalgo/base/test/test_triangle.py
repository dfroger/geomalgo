import unittest

from geomalgo import Point, Triangle

class TestTriangle(unittest.TestCase):

    def test_create_triangle(self):
        A = Point(0,0,0)
        B = Point(0,1,0)
        C = Point(1,0,0)

        triangle = Triangle(A,B,C)
        self.assertEqual(triangle.B.y, 1)

        triangle.B.y = 3
        self.assertEqual(triangle.B.y, 3)

        triangle.B = Point(-1, -2, -3)
        self.assertEqual(triangle.B.y, -2)

    def test_symetric_point(self):
        A = Point(0,0,0)
        B = Point(0,1,0)
        C = Point(1,0,0)
        triangle = Triangle(A,B,C)

        P = Point(1,2,-3)

        S = triangle.symetric_point(P)

        self.assertEqual(S.x, 1)
        self.assertEqual(S.y, 2)
        self.assertEqual(S.z, 3)

if __name__ == '__main__':
    unittest.main()
