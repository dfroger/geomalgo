import unittest

from geomalgo import Point, Triangle, Segment, \
                     intersec3d_triangle_segment

class TestIntersection(unittest.TestCase):

    def test_normal(self):

        A = Point(0, 0, 0)
        B = Point(1, 0, 0)
        C = Point(0, 1, 0)

        triangle = Triangle(A,B,C)

        S = Point(0.25, 0.25, -1)
        T = Point(0.25, 0.25,  1)

        segment = Segment(S,T)
    
        res = intersec3d_triangle_segment(triangle, segment)
        self.assertEqual(res, -2)

if __name__ == '__main__':
    unittest.main()
