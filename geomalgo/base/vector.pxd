cdef struct CVector:
    double x
    double y
    double z

cdef CVector* new_vector()

cdef void del_vector(CVector* cvector)

cdef void cross_product(CVector *c, CVector *a, CVector *b)

cdef void subtract_vector(CVector *c, CVector *b, CVector *a)

cdef double dot_product(CVector *a, CVector *b)

cdef double compute_norm(CVector *a)

cdef class Vector:
    cdef:
        CVector* cvector
