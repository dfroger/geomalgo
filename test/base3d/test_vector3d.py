import unittest

from geomalgo import Vector3D

class TestVector(unittest.TestCase):

    def test_dot_product(self):
        A = Vector3D(1,-2,3)
        B = Vector3D(4,6,5)
        x = A.dot(B)
        self.assertEqual(x, 7)

    def test_norm(self):
        A = Vector3D(1, 0, 0)
        self.assertEqual(A.norm, 1.)

        A = Vector3D(1, 2, 3)
        self.assertAlmostEqual(A.norm, 3.7416573867739413)

    def test_cross_product(self):
        A = Vector3D(1,2,3)
        B = Vector3D(4,6,5)
        V = A * B
        self.assertEqual(V.x, -8)
        self.assertEqual(V.y,  7)
        self.assertEqual(V.z, -2)

    def test_subtract_vector(self):
        A = Vector3D(1,2,3)
        B = Vector3D(4,6,5)
        V = B - A
        self.assertEqual(V.x, 3)
        self.assertEqual(V.y, 4)
        self.assertEqual(V.z, 2)

    def test_normalize(self):
        A = Vector3D(0, 3, 4)
        A.normalize()
        self.assertAlmostEqual(A.x, 0. )
        self.assertAlmostEqual(A.y, 0.6)
        self.assertAlmostEqual(A.z, 0.8)
        self.assertAlmostEqual(A.norm, 1.)

if __name__ == '__main__':
    unittest.main()
