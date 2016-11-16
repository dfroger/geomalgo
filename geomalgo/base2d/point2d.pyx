import math

import matplotlib.pyplot as plt

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
    """Test if a point P is left|on|right of an infinite line (AB).
    """

    res = c_is_left(A.cpoint2d, B.cpoint2d, P.cpoint2d)

    if comparer(res, 0.):
        raise ValueError("Point P in on line (AB)")

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
        """First coodinate"""
        def __get__(self):
            return self.cpoint2d.x
        def __set__(self, double x):
            self.cpoint2d.x = x

    property y:
        """Second coodinate"""
        def __get__(self):
            return self.cpoint2d.y
        def __set__(self, double y):
            self.cpoint2d.y = y

    def __cinit__(self):
        self.cpoint2d = new_point2d()

    def __dealloc__(self):
        del_point2d(self.cpoint2d)

    def __init__(self, x, y, index=0, name=None):
        self.cpoint2d.x = x
        self.cpoint2d.y = y
        self.index = index
        self.name = name

    def __str__(self):
        """String representation
        """

        return 'Point2D({self.x}, {self.y})'.format(self=self)

    def __add__(Point2D self, Vector2D vec):
        cdef:
            Point2D result = Point2D.__new__(Point2D)
        point2d_plus_vector2d(result.cpoint2d, self.cpoint2d, 1, vec.cvector2d)
        return result

    def __sub__(Point2D self, Point2D other):
        """Compute vector between two points

        Parameters
        ----------
        other: geomalgo.Point2D
            Point to compute vector to

        Returns
        -------
        geomalgo.Vector2D
            Vector between self and other

        """
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
        """
        Compute distance to another point

        Parameters
        ----------
        other: geomalgo.Point2D
            Other point to compute distance to

        Parameters
        ----------
        float
            Distance between the two points

        """
        return c_point2d_distance(self.cpoint2d, other.cpoint2d)

    def to_polar(self):
        """Compute coordinates in polar system

        Returns
        -------
        geomalgo.PolarPoint
            Point in polor system.

        """
        cdef:
            double r
            double theta
        r = sqrt(self.x**2 + self.y**2)
        theta = atan2(self.y, self.x);
        return PolarPoint(r, theta)

    def plot(self, name=None, marker='o', markersize=6, color='b',  offset=(0, 0.2)):
        """Plot point in a matplotlib figure

        Parameters
        ----------
        marker: string
            Matplotlib marker

        markersize: string
            Matplotlib markersize

        color: string
            Matplotlib color

        offset: tuple
            (x, y) offset at which annotate figure with point name (if any)

        """
        plt.plot(self.x, self.y, marker=marker, markersize=markersize, color=color)
        if name is None:
            name = self.name
        if name is not None:
            plt.text(self.x+offset[0], self.y+offset[1], name,
                     color=color,
                     horizontalalignment='center')
