from .point2d cimport CPoint2D, CVector2D, Point2D, Vector2D, subtract_points2d


# ============================================================================
# Structures
# ============================================================================


cdef struct CSegment2D:
    CPoint2D* A
    CPoint2D* B
    CVector2D* AB

cdef CSegment2D* new_segment2d()

cdef void del_segment2d(CSegment2D* csegment2d)

cdef inline void segment2d_set(CSegment2D* AB, CPoint2D* A, CPoint2D* B):
    AB.A = A
    AB.B = B
    subtract_points2d(AB.AB, AB.B, AB.A)


# ============================================================================
# Computational functions
# ============================================================================


cdef double segment2d_distance_point2d(CSegment2D* AB, CPoint2D* P)

cdef double segment2d_square_distance_point2d(CSegment2D* AB, CPoint2D* P)

cdef void segment2d_at(CPoint2D* P, CSegment2D* AB, double alpha)

cdef double segment2d_where(CSegment2D* AB, CPoint2D* P)

cdef void segment2d_middle(CPoint2D* M, CSegment2D* AB)


# ============================================================================
# Python API
# ============================================================================


cdef class Segment2D:

    cdef readonly:
        Vector2D AB
        double length

    cdef:
        Point2D A
        Point2D B
        CSegment2D csegment2d

    cdef alloc_new(Segment2D self)

cdef class Segment2DCollection:

    cdef:
        double[:,:] x
        double[:,:] y

    cdef get(Segment2DCollection self, int segment_index,
             CSegment2D* segment)

    cdef set(Segment2DCollection self, int segment_index,
             CPoint2D* A, CPoint2D * B)
