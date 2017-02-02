import matplotlib.pyplot as plt

from libc.stdlib cimport malloc, free
from libc.math cimport sqrt


# ============================================================================
# Structures
# ============================================================================


from .point2d cimport (
    subtract_points2d, CPoint2D, point2d_plus_vector2d,
    point2d_square_distance, point2d_distance
)
from .vector2d cimport compute_norm2d, dot_product2d
from ..inclusion.segment2d_point2d cimport segment2d_includes_collinear_point2d
from ..intersection.segment2d_segment2d cimport intersect_segment2d_segment2d

cdef CSegment2D* new_segment2d():
    return <CSegment2D*> malloc(sizeof(CSegment2D))


cdef void del_segment2d(CSegment2D* csegment2d):
    if csegment2d is not NULL:
        free(csegment2d)


# ============================================================================
# Computational functions
# ============================================================================


cdef double segment2d_distance_point2d(CSegment2D* AB, CVector2D* u,
                                       CPoint2D* P):
    return sqrt(segment2d_square_distance_point2d(AB, u, P))


cdef double segment2d_square_distance_point2d(CSegment2D* AB, CVector2D* u,
                                              CPoint2D* P):
    cdef:
        CPoint2D Pb
        CVector2D w
        double c1, c2, b

    subtract_points2d(&w, P, AB.A)

    c1 = dot_product2d(&w, u)

    if c1 <= 0:
        return point2d_square_distance(P, AB.A)

    c2 = dot_product2d(u, u)
    if c2 <= c1:
        return point2d_square_distance(P, AB.B)

    b = c1 / c2

    point2d_plus_vector2d(&Pb, AB.A, b, u)

    return point2d_square_distance(P, &Pb)


cdef double segment2d_where(CPoint2D* A, CVector2D* AB, CPoint2D* P):
    if AB.x != 0.:
        return (P.x - A.x) / AB.x
    else:
        return (P.y - A.y) / AB.y


cdef void segment2d_middle(CPoint2D* M, CSegment2D* AB):
    M.x = 0.5*(AB.A.x + AB.B.x)
    M.y = 0.5*(AB.A.y + AB.B.y)


# ============================================================================
# Python API
# ============================================================================


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
        self.u = Vector2D.__new__(Vector2D)

        # C points to Python.
        self.csegment2d.A = A.cpoint2d
        self.csegment2d.B = B.cpoint2d

        self.recompute()

    cdef alloc_new(Segment2D self):
        # TODO: put in __new__ and adapt __init__
        self.A = Point2D.__new__(Point2D)
        self.B = Point2D.__new__(Point2D)
        self.u = Vector2D.__new__(Vector2D)

        # C points to Python.
        self.csegment2d.A = self.A.cpoint2d
        self.csegment2d.B = self.B.cpoint2d

    def __str__(self):
        return "Segment2D(({self.A.x},{self.A.y}),({self.B.x},{self.B.y}))" \
               .format(self=self)

    def recompute(Segment2D self):
        """Must be called manually if any point coordinate changed"""
        subtract_points2d(self.u.cvector2d,
                          self.csegment2d.B, self.csegment2d.A)
        self.length = compute_norm2d(self.u.cvector2d)

    def point_distance(Segment2D self, Point2D P):
        return segment2d_distance_point2d(&self.csegment2d, self.u.cvector2d, P.cpoint2d)

    def at(Segment2D self, double coord):
        cdef:
            Point2D result = Point2D.__new__(Point2D)
        point2d_plus_vector2d(result.cpoint2d, self.A.cpoint2d, coord,
                              self.u.cvector2d)
        return result

    def where(Segment2D self, Point2D P):
        return segment2d_where(self.A.cpoint2d, self.u.cvector2d, P.cpoint2d)

    def includes_collinear_point(Segment2D self, Point2D P):
        return segment2d_includes_collinear_point2d(&self.csegment2d, P.cpoint2d)

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
                return None, None, (None, None, None, None)
            elif n == 1:
                return I0, None, (coords[0], coords[1], None, None)
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

    cdef get(Segment2DCollection self, int segment_index,
             CSegment2D* segment):
        segment.A.x = self.x[segment_index, 0]
        segment.A.y = self.y[segment_index, 0]

        segment.B.x = self.x[segment_index, 1]
        segment.B.y = self.y[segment_index, 1]

    cdef set(Segment2DCollection self, int segment_index,
               CPoint2D* A, CPoint2D * B):

        self.x[segment_index, 0] = A.x
        self.x[segment_index, 1] = B.x

        self.y[segment_index, 0] = A.y
        self.y[segment_index, 1] = B.y

    def __getitem__(Segment2DCollection self, int segment_index):
        cdef:
            Segment2D segment = Segment2D.__new__(Segment2D)
        segment.alloc_new()
        self.get(segment_index, &segment.csegment2d)
        segment.recompute()
        return segment
