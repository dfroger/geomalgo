cdef struct CVector:
    double x
    double y
    double z

cdef CVector* new_vector()

cdef void del_vector(CVector* cvector)

cdef class Vector:
    cdef:
        CVector* cvector
