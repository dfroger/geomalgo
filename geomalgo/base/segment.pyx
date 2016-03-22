from libc.stdlib cimport malloc, free

from .point cimport new_point, del_point

cdef CSegment* new_segment():
    return <CSegment*> malloc(sizeof(CSegment))

cdef void del_segment(CSegment* csegment):
    if csegment is not NULL:
        free(csegment)

cdef class Segment:

    def __init__(self, Point A, Point B):
        self.A = A
        self.B = B
