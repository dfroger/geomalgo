from libc.stdlib cimport malloc, free

from .parametric_segment2d cimport segment2d_at_parametric_coord
from ..inclusion.segment2d_point2d cimport segment2d_includes_point2d
from ..intersection.segment2d_segment2d cimport intersect_segment2d_segment2d

cdef CSegment2D* new_segment2d():
    return <CSegment2D*> malloc(sizeof(CSegment2D))

cdef void del_segment2d(CSegment2D* csegment2d):
    if csegment2d is not NULL:
        free(csegment2d)

cdef class Segment2D:

    def __init__(self, Point2D A, Point2D B):
        self.A = A
        self.B = B

    def __str__(self):
        return "Segment2D(({self.A.x},{self.A.y}),({self.B.x},{self.B.y}))" \
               .format(self=self)

    def at_parametric_coord(Segment2D self, double alpha):
        cdef:
            CSegment2D S
            Point2D result = Point2D.__new__(Point2D)
        S.A = self.A.cpoint2d
        S.B = self.B.cpoint2d
        segment2d_at_parametric_coord(S, alpha, result.cpoint2d)
        return result

    def includes_point(Segment2D self, Point2D P):
        cdef:
            CSegment2D S
        S.A = self.A.cpoint2d
        S.B = self.B.cpoint2d

        return segment2d_includes_point2d(&S, P.cpoint2d) == 1

    def intersect_segment(Segment2D self, Segment2D other, epsilon=1.E-08):
        cdef:
            CSegment2D S1, S2
            Point2D I0 = Point2D.__new__(Point2D)
            Point2D I1 = Point2D.__new__(Point2D)

        S1.A = self.A.cpoint2d
        S1.B = self.B.cpoint2d

        S2.A = other.A.cpoint2d
        S2.B = other.B.cpoint2d

        res = intersect_segment2d_segment2d(&S1, &S2, 
                                            I0.cpoint2d, I1.cpoint2d,
                                            epsilon=epsilon)

        if res == 0:
            return None

        elif res == 1:
            return I0

        elif res == 2:
            return Segment2D(I0, I1)
