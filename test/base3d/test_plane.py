import unittest

from geomalgo import Point3D, Vector3D, Plane

class TestPlane(unittest.TestCase):

    def test_creation(self):
        """
                       M(0.5,0.5,1.)
                       +
                       |              ^ z
                       |
        x    B(1,0,0)  |              A(0,0,0)
        <       +------|--------------+
              /        |            /
            /          +          /
          /     P(0.5,0.5,0)    /
        +---------------------+  C(0,1,0)

                          y
        """

        A = Point3D(0, 0, 0)
        B = Point3D(1, 0, 0)
        C = Point3D(0, 1, 0)

        P = Point3D(0.5, 0.5, 0)
        M = Point3D(0.5, 0.5, 1)

        normal = M - P

        plane = Plane(point=P, normal=normal)

        self.assertEqual(plane.point.x, 0.5)
        self.assertEqual(plane.normal.z, 1)


if __name__ == '__main__':
    unittest.main()
