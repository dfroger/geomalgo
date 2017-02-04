from .point2d cimport CPoint2D, CVector2D, Point2D, Vector2D, subtract_points2d


# ============================================================================
# Structures
# ============================================================================


cdef struct CSegment2D:
    CPoint2D* A
    CPoint2D* B

cdef CSegment2D* new_segment2d()

cdef void del_segment2d(CSegment2D* csegment2d)

cdef inline void segment2d_set(CSegment2D* AB, CPoint2D* A, CPoint2D* B):
    AB.A = A
    AB.B = B


# ============================================================================
# Computational functions
# ============================================================================


cdef double segment2d_distance_point2d(CSegment2D* AB, CVector2D* u,
                                       CPoint2D* P)

cdef double segment2d_square_distance_point2d(CSegment2D* AB, CVector2D* u,
                                              CPoint2D* P)

cdef double segment2d_where(CPoint2D* A, CVector2D* AB, CPoint2D* P)

cdef void segment2d_middle(CPoint2D* M, CSegment2D* AB)


# ============================================================================
# Python API
# ============================================================================


cdef class Segment2D:

    cdef readonly:
        Vector2D u
        double length

    cdef:
        Point2D A
        Point2D B
        CSegment2D csegment2d

    cdef alloc_new(Segment2D self)

cdef class Segment2DCollection:

    cdef:
        double[:] xa
        double[:] xb

        double[:] ya
        double[:] yb

        int size

    cdef void get(Segment2DCollection self, int segment_index,
                  CSegment2D* segment)

    cdef void set(Segment2DCollection self, int segment_index,
                  CPoint2D* A, CPoint2D * B)
