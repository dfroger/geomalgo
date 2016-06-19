cdef struct CVector2D:
    double x
    double y

cdef CVector2D* new_vector2d()

cdef void del_vector(CVector2D* V)

cdef void subtract_vector2d(CVector2D *c, CVector2D *b, CVector2D *a)

cdef double dot_product2d(CVector2D *a, CVector2D *b)

cdef double compute_norm2d(CVector2D *a)

cdef class Vector2D:
    cdef:
        CVector2D* cvector2d

