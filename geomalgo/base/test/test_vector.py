import unittest

from geomalgo import Vector

class TestVector(unittest.TestCase):

    def test_dot_product(self):
        A = Vector(1,-2,3)
        B = Vector(4,6,5)
        x = A.dot(B)
        self.assertEqual(x, 7)

    def test_norm(self):
        A = Vector(1, 0, 0)
        self.assertEqual(A.norm, 1.)

        A = Vector(1, 2, 3)
        self.assertAlmostEqual(A.norm, 3.7416573867739413)

    def test_cross_product(self):
        A = Vector(1,2,3)
        B = Vector(4,6,5)
        V = A * B
        self.assertEqual(V.x, -8)
        self.assertEqual(V.y,  7)
        self.assertEqual(V.z, -2)

    def test_subtract_vector(self):
        A = Vector(1,2,3)
        B = Vector(4,6,5)
        V = B - A
        self.assertEqual(V.x, 3)
        self.assertEqual(V.y, 4)
        self.assertEqual(V.z, 2)

if __name__ == '__main__':
    unittest.main()