cdef struct CPoint2D:
    double x
    double y

cdef CPoint2D* new_point2d()

cdef void del_point2d(CPoint2D* cpoint2d)

cdef inline double c_is_left(CPoint2D* A, CPoint2D* B, CPoint2D* P)

cdef double c_is_counterclockwise(CPoint2D* A, CPoint2D* B, CPoint2D* C)

cdef class Point2D:
    cdef:
        CPoint2D* cpoint2d
