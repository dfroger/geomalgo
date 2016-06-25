from .point2d cimport CPoint2D, point2d_plus_vector2d
from .vector2d cimport CVector2D
from ..base1d.parametric_coord1d cimport CParametricCoord1D

cdef struct CParametricSegment2D:
    CPoint2D* A
    CVector2D* AB

cdef CParametricSegment2D* new_parametric_segment2d()

cdef void del_parametric_segment2d(CParametricSegment2D* S)
