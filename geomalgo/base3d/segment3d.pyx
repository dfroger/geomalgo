from libc.stdlib cimport malloc, free


# ============================================================================
# Structures
# ============================================================================


cdef CSegment3D* new_segment3d():
    return <CSegment3D*> malloc(sizeof(CSegment3D))


cdef void del_segment3d(CSegment3D* csegment3d):
    if csegment3d is not NULL:
        free(csegment3d)


# ============================================================================
# Python API
# ============================================================================


cdef class Segment3D:

    def __init__(self, Point3D A, Point3D B):
        self.A = A
        self.B = B
