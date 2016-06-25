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

    property A:
        def __get__(self):
            return self.A
        def __set__(self, Point2D A):
            self.A = A
            self.csegment2d.A = A.cpoint2d

    property B:
        def __get__(self):
            return self.B
        def __set__(self, Point2D B):
            self.B = B
            self.csegment2d.B = B.cpoint2d

    def __init__(self, Point2D A, Point2D B):
        self.A = A
        self.B = B
        self.csegment2d.A = A.cpoint2d
        self.csegment2d.B = B.cpoint2d

    def __str__(self):
        return "Segment2D(({self.A.x},{self.A.y}),({self.B.x},{self.B.y}))" \
               .format(self=self)

    def at_parametric_coord(Segment2D self, double alpha):
        cdef:
            Point2D result = Point2D.__new__(Point2D)
        segment2d_at_parametric_coord(&self.csegment2d, alpha, result.cpoint2d)
        return result

    def includes_point(Segment2D self, Point2D P):
        return segment2d_includes_point2d(&self.csegment2d, P.cpoint2d) == 1

    def intersect_segment(Segment2D self, Segment2D other, epsilon=1.E-08):
        cdef:
            int res
            Point2D I0 = Point2D.__new__(Point2D)
            Point2D I1 = Point2D.__new__(Point2D)

        res = intersect_segment2d_segment2d(&self.csegment2d,
                                            &other.csegment2d, 
                                            I0.cpoint2d, I1.cpoint2d,
                                            epsilon=epsilon)

        if res == 0:
            return None

        elif res == 1:
            return I0

        elif res == 2:
            return Segment2D(I0, I1)
