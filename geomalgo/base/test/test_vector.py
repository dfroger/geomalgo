import unittest

from geomalgo import Vector

class TestVector(unittest.TestCase):

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
