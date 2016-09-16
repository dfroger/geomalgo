from ..base2d.point2d cimport CPoint2D
from ..base2d.segment2d cimport CSegment2D

cdef bint segment2d_includes_collinear_point2d(CSegment2D* S, CPoint2D* P)

