import unittest

from geomalgo import Point, Triangle, Segment, \
                     intersec3d_triangle_segment

class TestIntersection(unittest.TestCase):

    def test_intersection_in_triangle(self):
        """
        C      T       y ^    
        |  - /           | z
        |   I   -        |/
        A--/--------B    +-----> x
          S   
        """

        A = Point(0, 0, 0)
        B = Point(1, 0, 0)
        C = Point(0, 1, 0)
        triangle = Triangle(A,B,C)

        S = Point(0.25, 0.25, -1)
        T = Point(0.25, 0.25,  1)
        segment = Segment(S,T)
    
        I = intersec3d_triangle_segment(triangle, segment)

        self.assertEqual(I.x, 0.25)
        self.assertEqual(I.y, 0.25)
        self.assertEqual(I.z, 0.)

    def test_intersection_outside_triangle(self):
        A = Point(0, 0, 0)
        B = Point(1, 0, 0)
        C = Point(0, 1, 0)
        triangle = Triangle(A,B,C)

        S = Point(1., 1., -1)
        T = Point(1., 1.,  1)
        segment = Segment(S,T)
    
        with self.assertRaisesRegex(ValueError, 'There is no intersection'):
            intersec3d_triangle_segment(triangle, segment)

    def test_no_intersection(self):
        A = Point(0, 0, 0)
        B = Point(1, 0, 0)
        C = Point(0, 1, 0)
        triangle = Triangle(A,B,C)

        S = Point(0.25, 0.25, -1)
        T = Point(0.25, 0.25, -0.5)
        segment = Segment(S,T)
    
        with self.assertRaisesRegex(ValueError, 'There is no intersection'):
            intersec3d_triangle_segment(triangle, segment)

    def test_triangle_is_a_segment(self):
        A = Point(0, 0, 0)
        B = Point(0, 0, 0)
        C = Point(0, 1, 0)
        triangle = Triangle(A,B,C)

        S = Point(0.25, 0.25, -1)
        T = Point(0.25, 0.25,  1)
        segment = Segment(S,T)
    
        msg = 'Triangle is degenerated \(a segment or point\)'
        with self.assertRaisesRegex(ValueError, msg):
            intersec3d_triangle_segment(triangle, segment)

    def test_triangle_is_a_point(self):
        A = Point(0, 0, 0)
        B = Point(0, 0, 0)
        C = Point(0, 0, 0)
        triangle = Triangle(A,B,C)

        S = Point(0.25, 0.25, -1)
        T = Point(0.25, 0.25,  1)
        segment = Segment(S,T)
    
        msg = 'Triangle is degenerated \(a segment or point\)'
        with self.assertRaisesRegex(ValueError, msg):
            intersec3d_triangle_segment(triangle, segment)

    def test_triangle_and_segment_are_in_same_plane(self):
        A = Point(0, 0, 0)
        B = Point(1, 0, 0)
        C = Point(0, 1, 0)
        triangle = Triangle(A,B,C)

        S = Point(0., 0.5, 0)
        T = Point(0.5, 0., 0)
        segment = Segment(S,T)
    
        msg = 'Triangle and segment are in the same plane'
        with self.assertRaisesRegex(ValueError, msg):
            intersec3d_triangle_segment(triangle, segment)

    def test_triangle_and_segment_are_parallel(self):
        A = Point(0, 0, 0)
        B = Point(1, 0, 0)
        C = Point(0, 1, 0)
        triangle = Triangle(A,B,C)

        S = Point(0., 0.5, 1)
        T = Point(0.5, 0., 1)
        segment = Segment(S,T)
    
        with self.assertRaisesRegex(ValueError, 'There is no intersection'):
            intersec3d_triangle_segment(triangle, segment)

if __name__ == '__main__':
    unittest.main()
