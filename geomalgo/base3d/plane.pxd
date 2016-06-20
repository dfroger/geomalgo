from .point3d cimport Point3D, Vector3D

cdef class Plane:

    cdef public:
        Point3D point
        Vector3D normal
