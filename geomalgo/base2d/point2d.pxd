from libc.math cimport sqrt

from .vector2d cimport CVector2D, Vector2D


# ============================================================================
# Structures
# ============================================================================


cdef struct CPoint2D:
    double x
    double y


cdef CPoint2D* new_point2d()


cdef void del_point2d(CPoint2D* cpoint2d)


cdef inline bint point2d_equal(CPoint2D* A, CPoint2D* B):
    return A.x == B.x and A.y == B.y


# ============================================================================
# Computational functions
# ============================================================================


cdef void subtract_points2d(CVector2D* AB, const CPoint2D* B,
                            const CPoint2D* A)

cdef void point2d_plus_vector2d(CPoint2D* result, CPoint2D* start,
                                double factor, CVector2D* vector)

cdef inline double is_left(CPoint2D* A, CPoint2D* B, CPoint2D* P):
    return (B.x - A.x) * (P.y - A.y) \
         - (P.x - A.x) * (B.y - A.y)

cdef inline double point2d_distance(CPoint2D* A, CPoint2D* B):
    return sqrt(point2d_square_distance(A, B))

cdef inline double point2d_square_distance(CPoint2D* A, CPoint2D* B):
    return (B.x-A.x)**2 + (B.y-A.y)**2


# ============================================================================
# Python API
# ============================================================================


cdef class Point2D:
    cdef public:
        int index
        """Optional point index, for example fo a triangulation."""

        str name
        """Optional point name, to annotate a plot with."""
    cdef:
        CPoint2D* cpoint2d
