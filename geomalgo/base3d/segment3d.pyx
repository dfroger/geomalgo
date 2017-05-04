import matplotlib.pyplot as plt

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

    def plot(self, *args, **kwargs):
        ax = plt.gca(projection='3d')

        points = (self.A, self.B)

        x = [P.x for P in points]
        y = [P.y for P in points]
        z = [P.z for P in points]

        ax.plot(x, y ,z, *args, **kwargs)
