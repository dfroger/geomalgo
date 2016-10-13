from libc.math cimport fabs

from .point2d cimport CPoint2D, Point2D, c_is_left

cdef struct CTriangle2D:
    CPoint2D* A
    CPoint2D* B
    CPoint2D* C

cdef CTriangle2D* new_triangle2d()

cdef void del_triangle2d(CTriangle2D* ctri2d)

cdef bint triangle2d_includes_point2d(CTriangle2D* ctri2d, CPoint2D* P,
                                      double edge_width)

cdef inline double triangle2d_signed_area(CTriangle2D* T):
    return 0.5 * c_is_left(T.A, T.B, T.C)

cdef inline double triangle2d_area(CTriangle2D* T):
    return fabs(0.5 * c_is_left(T.A, T.B, T.C))

cdef inline void triangle2d_center(CTriangle2D* T, CPoint2D* C):
    C.x = (T.A.x + T.B.x + T.C.x) / 3.
    C.y = (T.A.y + T.B.y + T.C.y) / 3.

cdef inline void triangle2d_set(CTriangle2D* ABC,
                                CPoint2D* A, CPoint2D* B, CPoint2D* C):
    ABC.A = A
    ABC.B = B
    ABC.C = C

cdef inline double triangle2d_counterclockwise(CTriangle2D* T):
    """
    Returns
    -------

    Positive if triangle ABC is oriented counterclockwise.
    Negative if triangle ABC is oriented clockwise.
    Zero if triangle ABC is degenerated.

    See: http://geomalgorithms.com/a01-_area.html
    """
    return triangle2d_signed_area(T)

cdef void triangle2d_gradx_grady_det(CTriangle2D* T, double signed_area,
                                     double gradx[3], double grady[3],
                                     double det[3])

cdef class Triangle2D:
    cdef public:
        int index
        double signed_area
        double gradx[3]
        double grady[3]
        double det[3]

    cdef:
        Point2D A
        Point2D B
        Point2D C
        CTriangle2D ctri2d

    cdef _set_precomputed(Triangle2D self, Point2D A, Point2D B, Point2D C,
                          int index, double signed_area, double gradx[3],
                          double grady[3], double det[3])

    cdef alloc_new(Triangle2D self)
