from libc.math cimport sqrt

cdef struct CPoint2D:
    double x
    double y

cdef CPoint2D* new_point2d()

cdef void del_point2d(CPoint2D* cpoint2d)

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

cdef inline double c_is_counterclockwise(CPoint2D* A, CPoint2D* B, CPoint2D* C):
    """
    Positive if triangle ABC is oriented counterclockwise, negative else.

    See: http://geomalgorithms.com/a01-_area.html
    """
    return c_is_left(A, B, C)

cdef inline double c_point2d_distance(CPoint2D* A, CPoint2D* B):
    return sqrt((B.x-A.x)**2 + (B.y-A.y)**2)

cdef double c_signed_triangle2d_area(CPoint2D* A, CPoint2D* B, CPoint2D* C)

cdef class Point2D:
    cdef public:
        int index
    cdef:
        CPoint2D* cpoint2d
