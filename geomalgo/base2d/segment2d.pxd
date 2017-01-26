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

cdef CSegment2D* create_segment2d(CPoint2D* A, CPoint2D* B)


# ============================================================================
# Computational functions
# ============================================================================


cdef double segment2d_square_distance_point2d(CSegment2D* S, CPoint2D* P)

cdef double segment2d_distance_point2d(CSegment2D* S, CPoint2D* P)

cdef segment2d_at(CPoint2D* result, CSegment2D S, double coord)

cdef double segment2d_where(CSegment2D* AB, CPoint2D* P)

cdef void segment2d_middle(CPoint2D* M, CSegment2D* seg)

cdef inline void segment2d_compute_vector(CSegment2D* seg):
    subtract_points2d(seg.AB, seg.B, seg.A)


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

    cdef c_get(Segment2DCollection self, int segment_index,
               CSegment2D* segment)

    cdef c_set(Segment2DCollection self, int segment_index,
               CPoint2D* A, CPoint2D * B)
