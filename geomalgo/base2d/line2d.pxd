from .point2d cimport CPoint2D, Point2D

cdef struct CLine2D:
    CPoint2D* A
    CPoint2D* B

cdef CLine2D* new_line2d()

cdef void del_line2d(CLine2D* cline2d)

cdef CLine2D* create_line2d(CPoint2D* A, CPoint2D* B)

cdef class Line2D:

    cdef:
        Point2D A
        Point2D B
        CLine2D cline2d
