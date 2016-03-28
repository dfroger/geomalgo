import unittest

from geomalgo import Point2D

class TestPoint2D(unittest.TestCase):

    def test_property_x(self):
        A = Point2D(1,2)
        self.assertEqual(A.x, 1)
        A.x = 10
        self.assertEqual(A.x, 10)

if __name__ == '__main__':
    unittest.main()
