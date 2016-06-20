import unittest
from math import pi

from geomalgo import CylindricalPoint

class TestCylindricalPoint(unittest.TestCase):

    def test_to_cartesian(self):
        P = CylindricalPoint(r=2., theta=0., z=0.5)
        A = P.to_cartesian()
        self.assertAlmostEqual(A.x, 2.)
        self.assertAlmostEqual(A.y, 0.)
        self.assertAlmostEqual(A.z, 0.5)

        P = CylindricalPoint(r=2., theta=pi/2, z=0.5)
        A = P.to_cartesian()
        self.assertAlmostEqual(A.x, 0.)
        self.assertAlmostEqual(A.y, 2.)
        self.assertAlmostEqual(A.z, 0.5)

if __name__ == '__main__':
    unittest.main()
