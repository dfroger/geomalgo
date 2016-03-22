from .vector cimport CVector, Vector

cdef struct CPoint:
    double x
    double y
    double z

cdef CPoint* new_point()

cdef void del_point(CPoint* cpoint)

cdef void subtract_points(CVector * u, const CPoint * B, const CPoint * A)

cdef class Point:
    cdef:
        CPoint* cpoint
