import unittest

from geomalgo import Point, intersec3d_triangle_segment

class TestIntersection(unittest.TestCase):

    def test_normal(self):

        A = Point(0, 0, 0)
        B = Point(1, 0, 0)
        C = Point(0, 1, 0)

        #triangle = Triangle(A,B,C)

        #S = Point(0.25, 0.25, -1)
        #T = Point(0.25, 0.25,  1)

        #segment = Segment(S,T)
    
        #intersec3d_triangle_segment(triangle, segment)

if __name__ == '__main__':
    unittest.main()
