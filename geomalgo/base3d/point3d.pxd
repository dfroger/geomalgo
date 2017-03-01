from libc.math cimport sqrt

from .vector3d cimport CVector3D, Vector3D


# ============================================================================
# Structures
# ============================================================================


cdef struct CPoint3D:
    double x
    double y
    double z


cdef CPoint3D* new_point3d()


cdef void del_point3d(CPoint3D* cpoint3d)


# ============================================================================
# Computational functions
# ============================================================================


cdef void subtract_points3d(CVector3D * u, const CPoint3D * B,
                            const CPoint3D * A)


cdef void point3d_plus_vector3d(CPoint3D* result, CPoint3D* start,
                                double factor, CVector3D* vector)


cdef inline double c_point3d_distance(CPoint3D* A, CPoint3D* B):
    return sqrt((B.x-A.x)**2 + (B.y-A.y)**2 + (B.z-A.z)**2)


# ============================================================================
# Python API
# ============================================================================


cdef class Point3D:
    cdef public:
        int index
        str name
    cdef:
        CPoint3D* cpoint3d
