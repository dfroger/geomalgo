from libc.stdlib cimport malloc, free

cdef CSegment2D* new_segment2d():
    return <CSegment2D*> malloc(sizeof(CSegment2D))

cdef void del_segment2d(CSegment2D* csegment2d):
    if csegment2d is not NULL:
        free(csegment2d)

cdef class Segment2D:

    def __init__(self, Point2D A, Point2D B):
        self.A = A
        self.B = B
