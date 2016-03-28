cdef struct CPoint2D:
    double x
    double y

cdef CPoint2D* new_point2d()

cdef void del_point2d(CPoint2D* cpoint2d)

cdef class Point2D:
    cdef:
        CPoint2D* cpoint2d
