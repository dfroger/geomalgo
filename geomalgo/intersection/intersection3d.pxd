from ..base3d.point3d cimport CPoint3D
from ..base3d.segment3d cimport CSegment3D
from ..base3d.triangle3d cimport CTriangle3D

cdef int c_intersec3d_triangle_segment(CPoint3D* I, CTriangle3D* tri,
                                       CSegment3D* seg)
