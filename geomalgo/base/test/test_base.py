import unittest

import geomalgo as ga

class TestBase(unittest.TestCase):

    def test_vector_from_point_sub_point(self):
        A = ga.Point(1,2,3)
        B = ga.Point(6,5,4)
        V = B - A
        self.assertEqual(V.x, 5)
        self.assertEqual(V.y, 3)
        self.assertEqual(V.z, 1)

if __name__ == '__main__':
    unittest.main()
