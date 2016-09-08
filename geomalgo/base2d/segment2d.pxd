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

cdef void segment2d_middle(CPoint2D* M, CSegment2D* seg)

cdef class Segment2D:

    cdef readonly:
        Vector2D AB
        double length

    cdef:
        Point2D A
        Point2D B
        CSegment2D csegment2d

    cdef alloc_new(Segment2D self)

cdef class Segment2DCollection:

    cdef:
        double[:,:] x
        double[:,:] y

    cdef c_get(Segment2DCollection self, CSegment2D* segment,
               int segment_index)
