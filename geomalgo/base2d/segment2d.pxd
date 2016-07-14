from .point2d cimport CPoint2D, CVector2D, Point2D, Vector2D

cdef struct CSegment2D:
    CPoint2D* A
    CPoint2D* B
    CVector2D* AB
    
cdef CSegment2D* new_segment2d()

cdef void del_segment2d(CSegment2D* csegment2d)

cdef CSegment2D* create_segment2d(CPoint2D* A, CPoint2D* B)

cdef segment2d_at(CPoint2D* result, CSegment2D S, double coord)

cdef double segment2d_where(CSegment2D* AB, CPoint2D* P)

cdef class Segment2D:

    cdef readonly:
        Vector2D AB

    cdef:
        Point2D A
        Point2D B
        CSegment2D csegment2d
