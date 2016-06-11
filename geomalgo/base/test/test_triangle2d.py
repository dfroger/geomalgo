import unittest

from geomalgo import Point2D, Triangle2D

class TestTriangle2D(unittest.TestCase):
    """
      1 C
        | \
        |   \
        |     \
      0 A-------B
        0       1
    """

    def test_create(self):
        A = Point2D(0,0)
        B = Point2D(1,0)
        C = Point2D(0,1)

        triangle = Triangle2D(A, B, C)

if __name__ == '__main__':
    unittest.main()
