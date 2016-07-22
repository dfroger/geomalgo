import math

from libc.stdlib cimport malloc, free
from libc.math cimport sqrt, atan2

from ..polar cimport PolarPoint

cdef CPoint2D* new_point2d():
    return <CPoint2D*> malloc(sizeof(CPoint2D))

cdef void del_point2d(CPoint2D* cpoint2d):
    if cpoint2d is not NULL:
        free(cpoint2d)

cdef void subtract_points2d(CVector2D * u, const CPoint2D * B,
                            const CPoint2D * A):
    u.x = B.x - A.x
    u.y = B.y - A.y

cdef void point2d_plus_vector2d(CPoint2D* result, CPoint2D* start,
                                double factor, CVector2D* vector):
    result.x = start.x + factor*vector.x
    result.y = start.y + factor*vector.y

def is_left(Point2D A, Point2D B, Point2D P, comparer=math.isclose):
    """
    Test if a point P is left|on|right of an infinite line (AB).
    """

    res = c_is_left(A.cpoint2d, B.cpoint2d, P.cpoint2d)

    if comparer(res, 0.):
        raise ValueError("Point P in on line (AB)")

    return res > 0.

def is_counterclockwise(Point2D A, Point2D B, Point2D C, comparer=math.isclose):

    res = c_is_counterclockwise(A.cpoint2d, B.cpoint2d, C.cpoint2d)

    if comparer(res, 0.):
        raise ValueError("Triangle is degenerated (A, B and C are aligned)")

    return res > 0.

cdef class Point2D:
    """
    A point in 2D space

    Parameters
    ----------
    x: float
        First coordinate

    y: float
        Second coordinate
    """

    property x:
        def __get__(self):
            return self.cpoint2d.x
        def __set__(self, double x):
            self.cpoint2d.x = x

    property y:
        def __get__(self):
            return self.cpoint2d.y
        def __set__(self, double y):
            self.cpoint2d.y = y

    def __cinit__(self):
        self.cpoint2d = new_point2d()

    def __dealloc__(self):
        del_point2d(self.cpoint2d)

    def __init__(self, x, y, index=0):
        self.cpoint2d.x = x
        self.cpoint2d.y = y
        self.index = index

    def __str__(self):
        return 'Point2D({self.x}, {self.y})'.format(self=self)

    def __sub__(Point2D self, Point2D other):
        cdef:
            Vector2D vector = Vector2D.__new__(Vector2D)
        subtract_points2d(vector.cvector2d, self.cpoint2d, other.cpoint2d)
        return vector

    def __richcmp__(Point2D self, Point2D other, int op):
        if op == 2: # ==
            return point2d_equal(self.cpoint2d, other.cpoint2d)
        elif op == 3: # !=
            return not point2d_equal(self.cpoint2d, other.cpoint2d)
        else:
            assert False

    def distance(Point2D self, Point2D other):
        return c_point2d_distance(self.cpoint2d, other.cpoint2d)

    def to_polar(self):
        cdef:
            double r
            double theta
        r = sqrt(self.x**2 + self.y**2)
        theta = atan2(self.y, self.x);
        return PolarPoint(r, theta)
