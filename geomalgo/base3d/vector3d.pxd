cdef struct CVector3D:
    double x
    double y
    double z

cdef CVector3D* new_vector3d()

cdef void del_vector(CVector3D* V)

cdef void cross_product3d(CVector3D *c, CVector3D *a, CVector3D *b)

cdef void subtract_vector3d(CVector3D *c, CVector3D *b, CVector3D *a)

cdef double dot_product3d(CVector3D *a, CVector3D *b)

cdef double compute_norm3d(CVector3D *a)

cdef class Vector3D:
    cdef:
        CVector3D* cvector3d
