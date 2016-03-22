import unittest

from geomalgo import Point, Segment

class TestTriangle(unittest.TestCase):

    def test_create_triangle(self):
        A = Point(0,0,0)
        B = Point(0,1,0)

        triangle = Segment(A,B)
