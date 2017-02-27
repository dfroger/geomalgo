from .point3d cimport CPoint3D, Point3D


# ============================================================================
# Structures
# ============================================================================


cdef struct CSegment3D:
    CPoint3D* A
    CPoint3D* B


cdef CSegment3D* new_segment3d()


cdef void del_segment3d(CSegment3D* csegment3d)


# ============================================================================
# Python API
# ============================================================================


cdef class Segment3D:

    cdef public:
        Point3D A
        Point3D B
