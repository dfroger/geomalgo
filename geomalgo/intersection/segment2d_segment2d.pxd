from ..base1d.parametric_coord1d cimport CParametricCoord1D
from ..base2d.point2d cimport CPoint2D
from ..base2d.segment2d cimport CSegment2D

cdef int intersect_segment2d_segment2d(CSegment2D* S1, CSegment2D* S2, 
                                       CPoint2D* I0, CPoint2D* I1,
                                       CParametricCoord1D coords[4],
                                       double epsilon=*)
