from libc.math cimport sqrt

cdef struct CVector2D:
    double x
    double y

cdef CVector2D* new_vector2d()

cdef void del_vector2d(CVector2D* V)

cdef inline void vector2d_times_scalar(CVector2D *result, CVector2D *a, double scalar):
    result.x = a.x * scalar
    result.y = a.y * scalar

cdef inline double cross_product2d(CVector2D *a, CVector2D *b):
    return a.x*b.y - a.y*b.x

cdef inline void subtract_vector2d(CVector2D *c, CVector2D *b, CVector2D *a):
    c.x = b.x - a.x
    c.y = b.y - a.y

cdef inline void add_vector2d(CVector2D *c, CVector2D *b, CVector2D *a):
    c.x = a.x + b.x
    c.y = a.y + b.y

cdef inline double dot_product2d(CVector2D *a, CVector2D *b):
    return a.x*b.x + a.y*b.y

cdef inline double compute_norm2d(CVector2D *a):
    return sqrt(a.x*a.x + a.y*a.y)

cdef inline void normalize_vector2d(CVector2D *a):
    cdef:
        double norm = compute_norm2d(a)
    a.x /= norm
    a.y /= norm

cdef inline void compute_normal2d(CVector2D *vec, double vec_norm,
                                  CVector2D *normal):
    normal.x =  vec.y / vec_norm
    normal.y = -vec.x / vec_norm

cdef class Vector2D:
    cdef:
        CVector2D* cvector2d

