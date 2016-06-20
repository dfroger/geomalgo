from libc.math cimport sqrt

cdef struct CVector3D:
    double x
    double y
    double z

cdef CVector3D* new_vector3d()

cdef void del_vector(CVector3D* V)

cdef inline void cross_product3d(CVector3D *c, CVector3D *a, CVector3D *b):
    c.x = a.y*b.z - a.z*b.y
    c.y = a.z*b.x - a.x*b.z
    c.z = a.x*b.y - a.y*b.x

cdef inline void subtract_vector3d(CVector3D *c, CVector3D *b, CVector3D *a):
    c.x = b.x - a.x
    c.y = b.y - a.y
    c.z = b.z - a.z

cdef inline double dot_product3d(CVector3D *a, CVector3D *b):
    return a.x*b.x + a.y*b.y + a.z*b.z

cdef inline double compute_norm3d(CVector3D *a):
    return sqrt( a.x*a.x + a.y*a.y + a.z*a.z )

cdef class Vector3D:
    cdef:
        CVector3D* cvector3d
