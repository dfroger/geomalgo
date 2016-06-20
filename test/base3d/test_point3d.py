import unittest
from math import sqrt, pi

from geomalgo import Point3D

class TestPoint(unittest.TestCase):

    def test_property_x(self):
        A = Point3D(1,2,3)
        self.assertEqual(A.x, 1)
        A.x = 10
        self.assertEqual(A.x, 10)

    def test_index(self):
        A = Point3D(1,2,3)
        self.assertEqual(A.index, 0)
        
        B = Point3D(1,2,3, index=8)
        self.assertEqual(B.index, 8)

    def test_distance(self):
        A = Point3D(3,2,1)
        B = Point3D(4,3,2)
        dist = A.distance(B)
        expected_dist = sqrt(3.)
        self.assertAlmostEqual(dist, expected_dist)

    def test_vector_from_point_sub_point(self):
        A = Point3D(1,2,3)
        B = Point3D(6,5,4)
        V = B - A
        self.assertEqual(V.x, 5)
        self.assertEqual(V.y, 3)
        self.assertEqual(V.z, 1)

    def test_str(self):
        A = Point3D(3, 2, 1)
        expected_string = "Point3D(3.0, 2.0, 1.0)"
        string = str(A)
        self.assertEqual(string, expected_string)

    def test_to_cylindrical(self):
        A = Point3D(2, 0, 0.5)
        P = A.to_cylindrical()
        self.assertAlmostEqual(P.r, 2)
        self.assertAlmostEqual(P.theta, 0)
        self.assertEqual(P.z, 0.5)

        A = Point3D(0, 2, 0.5)
        P = A.to_cylindrical()
        self.assertAlmostEqual(P.r, 2.)
        self.assertAlmostEqual(P.theta, pi/2)
        self.assertEqual(P.z, 0.5)

if __name__ == '__main__':
    unittest.main()
