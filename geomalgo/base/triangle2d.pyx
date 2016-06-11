from libc.stdlib cimport malloc, free

from .polygon2d cimport CPolygon2D
from ..inclusion cimport polygon2d_winding_point2d

cdef CTriangle2D* new_triangle2d():
    return <CTriangle2D*> malloc(sizeof(CTriangle2D))

cdef void del_triangle2d(CTriangle2D* ctri2d):
    if ctri2d is not NULL:
        free(ctri2d)

cdef bint triangle2d_includes_point2d(CTriangle2D* ctri2d, CPoint2D* P):
    cdef:
        int winding
        CPolygon2D cpolygon2d
        double x[3]
        double y[3]

    x[0] = ctri2d.A.x
    y[0] = ctri2d.A.y

    x[1] = ctri2d.B.x
    y[1] = ctri2d.B.y

    x[2] = ctri2d.C.x
    y[2] = ctri2d.C.y

    cpolygon2d.x = x
    cpolygon2d.y = y
    cpolygon2d.points_number = 3

    winding = polygon2d_winding_point2d(&cpolygon2d, P)
    return winding != 0

cdef class Triangle2D:
            
    def __init__(self, Point2D A, Point2D B, Point2D C):
        self.A = A
        self.B = B
        self.C = C

    def includes_point(Triangle2D self, Point2D point):
        cdef:
            CTriangle2D ctri2d
        ctri2d.A = self.A.cpoint2d
        ctri2d.B = self.B.cpoint2d
        ctri2d.C = self.C.cpoint2d

        return triangle2d_includes_point2d(&ctri2d, point.cpoint2d)
