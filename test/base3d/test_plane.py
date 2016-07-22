import unittest

from geomalgo import Point3D, Vector3D, Plane

class TestPlane(unittest.TestCase):

    def test_creation(self):

        A = Point3D(0, 0, 0)
        B = Point3D(1, 0, 0)
        C = Point3D(0, 1, 0)

        P = Point3D(0.5, 0.5, 0)
        M = Point3D(0.5, 0.5, 1)

        normal = M - P

        plane = Plane(point=P, normal=normal)

        self.assertEqual(plane.point.x, 0.5)
        self.assertEqual(plane.normal.z, 1)

    def test_point_projection_on_horizontal_plane(self):
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

        plane = Plane(point=P, normal=M-P)

        projection = plane.project_point(M)
        self.assertAlmostEqual(projection.x, P.x)
        self.assertAlmostEqual(projection.y, P.y)
        self.assertAlmostEqual(projection.z, P.z)

    def test_point_projection_on_vertical_plane(self):
        """
                                     ^ z

                                     + C(0,0,1)
                                   / |
                                 /   |
                               /     |
        M(0.5,0.5,0.5)  x    +   P   |
        x---------------<----|---+   + A(0,0,0)
                             |     /
                             |   /
                             | /
                             +  B(0,1,0)

                         y
        """

        A = Point3D(0,0,0)
        B = Point3D(0,1,0)
        C = Point3D(0,0,1)

        P = Point3D(0. , 0.5, 0.5)
        M = Point3D(0.5, 0.5, 0.5)

        plane = Plane(point=P, normal=M-P)

        projection = plane.project_point(M)
        self.assertAlmostEqual(projection.x, P.x)
        self.assertAlmostEqual(projection.y, P.y)
        self.assertAlmostEqual(projection.z, P.z)

if __name__ == '__main__':
    unittest.main()
