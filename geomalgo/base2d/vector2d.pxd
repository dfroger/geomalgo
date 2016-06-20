from libc.math cimport sqrt

cdef struct CVector2D:
    double x
    double y

cdef CVector2D* new_vector2d()

cdef void del_vector2d(CVector2D* V)

cdef inline double cross_product2d(CVector2D *a, CVector2D *b):
    return a.x*b.y - a.y*b.x

cdef inline void subtract_vector2d(CVector2D *c, CVector2D *b, CVector2D *a):
    c.x = b.x - a.x
    c.y = b.y - a.y

cdef inline double dot_product2d(CVector2D *a, CVector2D *b):
    return a.x*b.x + a.y*b.y

cdef inline double compute_norm2d(CVector2D *a):
    return sqrt(a.x*a.x + a.y*a.y)

cdef class Vector2D:
    cdef:
        CVector2D* cvector2d

