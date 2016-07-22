from .point2d cimport CPoint2D, Point2D, c_is_left
from ..triangulation cimport CTriangulation2D

cdef struct CTriangle2D:
    CPoint2D* A
    CPoint2D* B
    CPoint2D* C

cdef CTriangle2D* new_triangle2d()

cdef void del_triangle2d(CTriangle2D* ctri2d)

cdef void triangle2d_from_triangulation2d(CTriangle2D* ctriangle2d,
                                          CTriangulation2D* ctriangulation2d,
                                          int triangle_index)

cdef bint triangle2d_includes_point2d(CTriangle2D* ctri2d, CPoint2D* P)

cdef inline double triangle2d_signed_area(CTriangle2D* T):
    return 0.5 * c_is_left(T.A, T.B, T.C)

cdef class Triangle2D:
    cdef public:
        int index
        double signed_area
        double area

    cdef:
        Point2D A
        Point2D B
        Point2D C
        CTriangle2D ctri2d
