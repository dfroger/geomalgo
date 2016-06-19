import unittest
from math import pi

from geomalgo import PolarPoint

class TestPolarPoint(unittest.TestCase):

    def test_to_cartesian(self):
        P = PolarPoint(r=2., theta=0.)
        A = P.to_cartesian()
        self.assertAlmostEqual(A.x, 2.)
        self.assertAlmostEqual(A.y, 0.)

        P = PolarPoint(r=2., theta=pi/2)
        A = P.to_cartesian()
        self.assertAlmostEqual(A.x, 0.)
        self.assertAlmostEqual(A.y, 2.)

if __name__ == '__main__':
    unittest.main()
