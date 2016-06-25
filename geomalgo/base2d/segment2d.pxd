from .point2d cimport CPoint2D, Point2D, Vector2D
from .parametric_segment2d cimport CParametricSegment2D
from ..base1d.parametric_coord1d cimport CParametricCoord1D 

cdef struct CSegment2D:
    CPoint2D* A
    CPoint2D* B
    
cdef CSegment2D* new_segment2d()

cdef void del_segment2d(CSegment2D* csegment2d)

cdef segment2d_to_parametric(CParametricSegment2D* PS, CSegment2D* S)

cdef segment2d_at_parametric_coord(CSegment2D* seg, CParametricCoord1D alpha,
                                   CPoint2D* result)

cdef class Segment2D:

    cdef readonly:
        Vector2D AB

    cdef:
        Point2D A
        Point2D B
        CSegment2D csegment2d
        CParametricSegment2D cparametric_segment2d
