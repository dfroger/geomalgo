from libc.math cimport fabs

from ..base.point cimport Point, CPoint, new_point, del_point, \
                          subtract_points, point_plus_vector
from ..base.vector cimport CVector, cross_product, dot_product
from ..base.segment cimport Segment, CSegment, new_segment, del_segment
from ..base.triangle cimport Triangle, CTriangle, new_triangle, del_triangle
from ..work cimport work

def intersec3d_triangle_segment(Triangle triangle, Segment segment):
    """
    Find intersection of 3D triangle and a segment 
    """
    cdef:
        CTriangle* tri = new_triangle()
        CSegment* seg = new_segment()
        CPoint* I = new_point()

    tri.A = triangle.A.cpoint
    tri.B = triangle.B.cpoint
    tri.C = triangle.C.cpoint

    seg.A = segment.A.cpoint
    seg.B = segment.B.cpoint

    res = c_intersec3d_triangle_segment(I, tri, seg)
    
    del_triangle(tri)
    del_segment(seg)

    if res == -1:
        del_point(I)
        raise ValueError('Triangle is degenerated (a segment or point)')

    elif res == 0:
        del_point(I)
        raise ValueError('There is no intersection')

    elif res == 2:
        del_point(I)
        raise ValueError('Triangle and segment are in the same plane')

    cdef:
        Point intersection = Point.__new__(Point)

    intersection.cpoint = I

    return intersection

cdef int c_intersec3d_triangle_segment(CPoint* I, CTriangle* tri, CSegment* seg):
    """
    Find intersection of 3D triangle and a segment 

    Return value:
        * -1 = triangle is degenerated (a segment or point)
        *  0 = disjoint (no intersection)
        *  1 = intersect in unique point
        *  2 = are in the same plane

    Implementation of 
    http://geomalgorithms.com/a06-_intersect-2.html
    http://geomalgorithms.com/a06-_intersect-2.html#intersect3D_RayTriangle%28%29
    """
    cdef:
        CVector* u = &work.vector0
        CVector* v = &work.vector1
        CVector* n = &work.vector2
        CVector* direction = &work.vector3
        CVector* w0 = &work.vector4
        CVector* w = &work.vector5
        double r, a, b
        double  uu, uv, vv, wu, wv, D
        double s,t
        # anything that avoids division overflow.
        double SMALL_NUM = 0.00000001

    # Get triangle edge vectors
    subtract_points(u, tri.B, tri.A)
    subtract_points(v, tri.C, tri.A)

    # Get triangle plane normal.
    cross_product(n, u, v)

    # Check for degenerated triangle.
    if n.x==0 and n.y==0 and n.z==0:
        return -1
    
    # Segment direction vector.
    subtract_points(direction, seg.B, seg.A)

    #
    subtract_points(w0, seg.A, tri.A)

    a = - dot_product(n, w0)
    b = dot_product(n, direction)

    # Check if segment is parallel to triangle plane.
    if fabs(b) < SMALL_NUM:
        if a == 0:
            # Segment lies in triangle plane.
            return 2
        else:
            # Segment is disjoint from plane.
            return 0

    # Get intersect point of ray with triangle plane.
    r = a / b
    if r < 0.0 or 1.0 < r:
        # No intersect.
        return 0

    # Intersection of segment and plane.
    point_plus_vector(I, seg.A, r, direction)

    # is I inside tri?
    uu = dot_product(u,u)
    uv = dot_product(u,v)
    vv = dot_product(v,v)
    subtract_points(w, I, tri.A)
    wu = dot_product(w,u)
    wv = dot_product(w,v)
    D = uv*uv - uu*vv

    # Get and test parametric coords.
    s = (uv*wv - vv*wu) / D
    if s < 0.0 or s > 1.0:
        # I is outside tri
        return 0
    t = (uv*wu - uu*wv) / D
    if t < 0.0 or (s + t) > 1.0:
        # I is outside tri
        return 0

    # I is in tri
    return 1
