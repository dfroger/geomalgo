from .point2d cimport CPoint2D, Point2D

cdef struct CSegment2D:
    CPoint2D* A
    CPoint2D* B
    
cdef CSegment2D* new_segment2d()

cdef void del_segment2d(CSegment2D* csegment2d)

cdef class Segment2D:

    cdef public:
        Point2D A
        Point2D B
