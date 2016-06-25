from libc.stdlib cimport malloc, free

cdef CParametricSegment2D* new_parametric_segment2d():
    return <CParametricSegment2D*> malloc(sizeof(CParametricSegment2D))

cdef void del_parametric_segment2d(CParametricSegment2D* S):
    if S is not NULL:
        free(S)

cdef segment2d_at_parametric_coord(CSegment2D* seg, CParametricCoord1D alpha,
                                   CPoint2D* result):
    result.x = (1-alpha)*seg.A.x + alpha*seg.B.x
    result.y = (1-alpha)*seg.A.y + alpha*seg.B.y

