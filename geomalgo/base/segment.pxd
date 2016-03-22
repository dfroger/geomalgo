from .point cimport CPoint, Point

cdef struct CSegment:
    CPoint* A
    CPoint* B
    
cdef CSegment* new_segment()

cdef void del_segment(CSegment* csegment)

cdef class Segment:

    cdef public:
        Point A
        Point B
