import unittest

from geomalgo import Point2DWithIndex


class TestPoint2D(unittest.TestCase):

    def test_property_x(self):
        A = Point2DWithIndex(1,2, 7)
        self.assertEqual(A.x, 1)
        A.x = 10
        self.assertEqual(A.x, 10)

    def test_property_index(self):
        A = Point2DWithIndex(1,2, 7)
        self.assertEqual(A.index, 7)
        A.index = 8
        self.assertEqual(A.index, 8)

if __name__ == '__main__':
    unittest.main()
