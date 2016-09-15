import matplotlib.pyplot as plt

from libc.stdlib cimport malloc, free

from .point2d cimport subtract_points2d, CPoint2D, point2d_plus_vector2d
from .vector2d cimport compute_norm2d
from ..inclusion.segment2d_point2d cimport segment2d_includes_point2d
from ..intersection.segment2d_segment2d cimport intersect_segment2d_segment2d

cdef CSegment2D* new_segment2d():
    return <CSegment2D*> malloc(sizeof(CSegment2D))

cdef void del_segment2d(CSegment2D* csegment2d):
    if csegment2d is not NULL:
        free(csegment2d)

cdef CSegment2D* create_segment2d(CPoint2D* A, CPoint2D* B):
    cdef:
        CSegment2D* seg = new_segment2d()
    seg.A = A
    seg.B = B
    subtract_points2d(seg.AB, seg.B, seg.A)
    return seg

cdef segment2d_at(CPoint2D* result, CSegment2D S, double coord):
    """
    A     P
    +-----+-----> AB

    P = A + coord*AB

    Note
    ----

    This can be derived from 1D interpolation formuale:

        a   x       b
        +---+-------+

        alpha = (x-a) / (b-a)

        fx = (1-alpha)*fa + alpha*fb
           = fa + alpha*(fb-fa)

    So:
        px = xa + alpha*(xb-xa)
        py = ya + alpha*(yb-ya)

    However, we keep simple and use 'point2d_plus_vector2d' function instead
    of generic inteporlation functions.
    """
    point2d_plus_vector2d(result, S.A, coord, S.AB)

cdef double segment2d_where(CSegment2D* seg, CPoint2D* P):
    """
    Compute coordinate of Point p in segment AB

    Assume point in on segment

    A----P-------B
    """

    if seg.AB.x != 0.:
        return (P.x - seg.A.x) / seg.AB.x
    else:
        return (P.y - seg.A.y) / seg.AB.y

cdef void segment2d_middle(CPoint2D* M, CSegment2D* seg):
    M.x = 0.5*(seg.A.x + seg.B.x)
    M.y = 0.5*(seg.A.y + seg.B.y)

cdef class Segment2D:

    property A:
        def __get__(self):
            return self.A
        def __set__(self, Point2D A):
            self.A = A
            # C points to Python.
            self.csegment2d.A = A.cpoint2d

    property B:
        def __get__(self):
            return self.B
        def __set__(self, Point2D B):
            self.B = B
            # C points to Python.
            self.csegment2d.B = B.cpoint2d

    def __init__(self, Point2D A, Point2D B):
        self.A = A
        self.B = B
        self.AB = Vector2D.__new__(Vector2D)

        # C points to Python.
        self.csegment2d.A = A.cpoint2d
        self.csegment2d.B = B.cpoint2d
        self.csegment2d.AB = self.AB.cvector2d

        self.recompute()

    cdef alloc_new(Segment2D self):
        # TODO: put in __new__ and adapt __init__
        self.A = Point2D.__new__(Point2D)
        self.B = Point2D.__new__(Point2D)
        self.AB = Vector2D.__new__(Vector2D)

        # C points to Python.
        self.csegment2d.A = self.A.cpoint2d
        self.csegment2d.B = self.B.cpoint2d
        self.csegment2d.AB = self.AB.cvector2d

    def __str__(self):
        return "Segment2D(({self.A.x},{self.A.y}),({self.B.x},{self.B.y}))" \
               .format(self=self)

    def recompute(Segment2D self):
        """Must be called manually if any point coordinate changed"""
        subtract_points2d(self.csegment2d.AB,
                          self.csegment2d.B, self.csegment2d.A)
        self.length = compute_norm2d(self.csegment2d.AB)

    def at(Segment2D self, double coord):
        cdef:
            Point2D result = Point2D.__new__(Point2D)
        segment2d_at(result.cpoint2d, self.csegment2d, coord)
        return result

    def where(Segment2D self, Point2D P):
        return segment2d_where(&self.csegment2d, P.cpoint2d)

    def includes_point(Segment2D self, Point2D P):
        return segment2d_includes_point2d(&self.csegment2d, P.cpoint2d)

    def intersect_segment(Segment2D self, Segment2D other, epsilon=1.E-08,
                          return_coords=False):
        cdef:
            int n
            Point2D I0 = Point2D.__new__(Point2D)
            Point2D I1 = Point2D.__new__(Point2D)
            double coords[4]

        n = intersect_segment2d_segment2d(&self.csegment2d,
                                          &other.csegment2d,
                                          I0.cpoint2d, I1.cpoint2d,
                                          coords,
                                          epsilon=epsilon)

        if return_coords:
            if n == 0:
                return None, None, ()
            elif n == 1:
                return I0, None, (coords[0], coords[1])
            elif n == 2:
                return I0, I1, (coords[0], coords[1], coords[2], coords[3])
        else:
            if n == 0:
                return None, None
            elif n == 1:
                return I0, None
            elif n == 2:
                return I0, I1

    def compute_middle(self):
        cdef:
            Point2D M = Point2D.__new__(Point2D)
        segment2d_middle(M.cpoint2d, &self.csegment2d)
        return M

    def plot(self, style='b-'):
        x = [self.A.x, self.B.x]
        y = [self.A.y, self.B.y]
        plt.plot(x, y, style)


cdef class Segment2DCollection:

    def __init__(self, double[:,:] x, double[:,:] y):
        self.x = x
        self.y = y

    cdef c_get(Segment2DCollection self, int segment_index,
               CSegment2D* segment):
        segment.A.x = self.x[segment_index, 0]
        segment.A.y = self.y[segment_index, 0]

        segment.B.x = self.x[segment_index, 1]
        segment.B.y = self.y[segment_index, 1]

    cdef c_set(Segment2DCollection self, int segment_index,
               CPoint2D* A, CPoint2D * B):

        self.x[segment_index, 0] = A.x
        self.x[segment_index, 1] = B.x

        self.y[segment_index, 0] = A.y
        self.y[segment_index, 1] = B.y

    def __getitem__(Segment2DCollection self, int segment_index):
        cdef:
            Segment2D segment = Segment2D.__new__(Segment2D)
        segment.alloc_new()
        self.c_get(segment_index, &segment.csegment2d)
        segment.recompute()
        return segment
