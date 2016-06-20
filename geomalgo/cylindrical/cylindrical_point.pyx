from libc.math cimport sin, cos

from ..base3d.point3d cimport Point3D

cdef class CylindricalPoint:

    def __init__(self, r, theta, z):
        self.r = r
        self.theta = theta
        self.z = z

    def to_cartesian(self):
        cdef:
            double x
            double y
        x = self.r * cos(self.theta)
        y = self.r * sin(self.theta)
        return Point3D(x, y, self.z)

