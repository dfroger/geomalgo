from libc.stdlib cimport malloc, free

from ..inclusion.segment2d_point2d cimport segment2d_includes_point2d

cdef CSegment2D* new_segment2d():
    return <CSegment2D*> malloc(sizeof(CSegment2D))

cdef void del_segment2d(CSegment2D* csegment2d):
    if csegment2d is not NULL:
        free(csegment2d)

cdef class Segment2D:

    def __init__(self, Point2D A, Point2D B):
        self.A = A
        self.B = B

    def includes_point(Segment2D self, Point2D P):
        cdef:
            CSegment2D S
        S.A = self.A.cpoint2d
        S.B = self.B.cpoint2d

        return segment2d_includes_point2d(&S, P.cpoint2d) == 1
