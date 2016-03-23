from ..base.point cimport CPoint
from ..base.segment cimport CSegment
from ..base.triangle cimport CTriangle

cdef int c_intersec3d_triangle_segment(CPoint* I, CTriangle* tri, CSegment* seg)

