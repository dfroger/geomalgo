from ..base.point cimport CPoint, subtract_points
from ..base.vector cimport CVector
from ..base.segment cimport Segment, CSegment, new_segment, del_segment
from ..base.triangle cimport Triangle, CTriangle, new_triangle, del_triangle
from ..work cimport work

def intersec3d_triangle_segment(Triangle triangle, Segment segment):
    cdef:
        CTriangle* ctriangle = new_triangle()
        CSegment* csegment = new_segment()

    ctriangle.A = triangle.A.cpoint
    ctriangle.B = triangle.B.cpoint
    ctriangle.C = triangle.C.cpoint

    csegment.A = segment.A.cpoint
    csegment.B = segment.B.cpoint

    res = c_intersec3d_triangle_segment(ctriangle, csegment)

    del_triangle(ctriangle)
    del_segment(csegment)

    return res

cdef int c_intersec3d_triangle_segment(CTriangle* tri, CSegment* seg):
    """
    Return value:
        * -1 = triangle is degenerated (a segment or point)
        *  0 = disjoint (no intersection)
        *  1 = intersect in unique point
        *  2 = are in the same plane

    Implementation of 
    http://geomalgorithms.com/a06-_intersect-2.html
    http://geomalgorithms.com/a06-_intersect-2.html#intersect3D_RayTriangle%28%29
                      
    C      T       y ^    
    |  - /           | z
    |   I   -        |/
    A--/--------B    +-----> x
      S   
    """
    
    cdef:
        CVector* u = &work.vector0
        CVector* v = &work.vector1

    # Get triangle edge vectors
    subtract_points(u, tri.B, tri.A)
    subtract_points(v, tri.C, tri.A)
    print(u.x, u.y)

    #v0.from_points(triangle.B, triangle.A)

    #print(u.x, u.y)
    
    # Get triangle plane normal.

    return -2

