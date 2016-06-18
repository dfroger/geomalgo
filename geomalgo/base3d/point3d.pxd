from .vector3d cimport CVector3D, Vector3D

cdef struct CPoint3D:
    double x
    double y
    double z

cdef CPoint3D* new_point3d()

cdef void del_point3d(CPoint3D* cpoint)

cdef void subtract_points3d(CVector3D * u, const CPoint3D * B,
                            const CPoint3D * A)

cdef void point3d_plus_vector3d(CPoint3D* result, CPoint3D* start,
                                double factor, CVector3D* vector)

cdef class Point3D:
    cdef public:
        int index
    cdef:
        CPoint3D* cpoint
