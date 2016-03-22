import unittest

from geomalgo import Point, Triangle

class TestTriangle(unittest.TestCase):

    def test_create_triangle(self):
        A = Point(0,0,0)
        B = Point(0,1,0)
        C = Point(1,0,0)

        triangle = Triangle(A,B,C)
