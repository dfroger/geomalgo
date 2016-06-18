import math

from libc.stdlib cimport malloc, free

cdef CPoint2D* new_point2d():
    return <CPoint2D*> malloc(sizeof(CPoint2D))

cdef void del_point2d(CPoint2D* cpoint2d):
    if cpoint2d is not NULL:
        free(cpoint2d)

cdef double c_signed_triangle2d_area(CPoint2D* A, CPoint2D* B, CPoint2D* C):
    return 0.5 * c_is_left(A, B, C)

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

def signed_triangle2d_area(Point2D A, Point2D B, Point2D C):
    return c_signed_triangle2d_area(A.cpoint2d, B.cpoint2d, C.cpoint2d)

cdef class Point2D:

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
