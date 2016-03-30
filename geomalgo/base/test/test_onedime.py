import unittest

from geomalgo import symetric_1d

class TestSymetric1D(unittest.TestCase):

    def test_normal(self):
        x = 1
        center = 3
        self.assertEqual(symetric_1d(center,x), 5)

if __name__ == '__main__':
    unittest.main()
