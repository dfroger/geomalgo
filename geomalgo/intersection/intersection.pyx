from ..base.point cimport CPoint
#from ..base.vector cimport Vector
from ..base.segment cimport Segment, CSegment, new_segment, del_segment
from ..base.triangle cimport Triangle, CTriangle, new_triangle, del_triangle
#from ..work.work cimport v0

#cdef:
    #Vector u = Vector(0,0,0)


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

cdef int c_intersec3d_triangle_segment(CTriangle* ctriangle, CSegment* csegment):
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
    
    return 2

    #cdef:
        #Vector u = work.vector0, v, n

    # Get triangle edge vectors
    #v0.from_points(triangle.B, triangle.A)

    #print(u.x, u.y)
    
    # Get triangle plane normal.
