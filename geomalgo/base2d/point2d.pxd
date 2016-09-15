from libc.math cimport sqrt

from .vector2d cimport CVector2D, Vector2D

cdef struct CPoint2D:
    double x
    double y

cdef CPoint2D* new_point2d()

cdef void del_point2d(CPoint2D* cpoint2d)

cdef void subtract_points2d(CVector2D * u, const CPoint2D * B,
                            const CPoint2D * A)

cdef void point2d_plus_vector2d(CPoint2D* result, CPoint2D* start,
                                double factor, CVector2D* vector)

cdef inline double c_is_left(CPoint2D* A, CPoint2D* B, CPoint2D* P):
    """
    Test if a point P is left|on|right of an infinite line (AB).

    Returns:
      - >0 if P is left of the line through A to B.
      - =0 if P is on the line (AB).
      - <0 if P is right of the line through A to B.
    """
    return (B.x - A.x) * (P.y - A.y) \
         - (P.x - A.x) * (B.y - A.y)

cdef inline double c_point2d_distance(CPoint2D* A, CPoint2D* B):
    return sqrt((B.x-A.x)**2 + (B.y-A.y)**2)

cdef inline bint point2d_equal(CPoint2D* A, CPoint2D* B):
    return A.x == B.x and A.y == B.y

cdef class Point2D:
    cdef public:
        int index
        str name
    cdef:
        CPoint2D* cpoint2d
