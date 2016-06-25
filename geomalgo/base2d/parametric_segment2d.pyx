from libc.stdlib cimport malloc, free

cdef CParametricSegment2D* new_parametric_segment2d():
    return <CParametricSegment2D*> malloc(sizeof(CParametricSegment2D))

cdef void del_parametric_segment2d(CParametricSegment2D* S):
    if S is not NULL:
        free(S)
