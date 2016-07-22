from libc.math cimport fabs

from ..base3d.point3d cimport (
    Point3D, CPoint3D, new_point3d, del_point3d, subtract_points3d,
    point3d_plus_vector3d
)
from ..base3d.vector3d cimport CVector3D, cross_product3d, dot_product3d
from ..base3d.segment3d cimport (
    Segment3D, CSegment3D, new_segment3d, del_segment3d
)
from ..base3d.triangle3d cimport (
    Triangle3D, CTriangle3D, new_triangle3d, del_triangle3d
)

def intersec3d_triangle_segment(Triangle3D triangle, Segment3D segment):
    """
    Find intersection of 3D triangle and a segment
    """
    cdef:
        CTriangle3D* tri = new_triangle3d()
        CSegment3D* seg = new_segment3d()
        CPoint3D* I = new_point3d()

    tri.A = triangle.A.cpoint3d
    tri.B = triangle.B.cpoint3d
    tri.C = triangle.C.cpoint3d

    seg.A = segment.A.cpoint3d
    seg.B = segment.B.cpoint3d

    res = c_intersec3d_triangle_segment(I, tri, seg)

    del_triangle3d(tri)
    del_segment3d(seg)

    if res == -1:
        del_point3d(I)
        raise ValueError('Triangle is degenerated (a segment or point)')

    elif res == 0:
        del_point3d(I)
        raise ValueError('There is no intersection')

    elif res == 2:
        del_point3d(I)
        raise ValueError('Triangle and segment are in the same plane')

    cdef:
        Point3D intersection = Point3D.__new__(Point3D)

    intersection.cpoint3d = I

    return intersection

cdef int c_intersec3d_triangle_segment(CPoint3D* I, CTriangle3D* tri,
                                       CSegment3D* seg):
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
        CVector3D u, v, n, direction, w0, w
        double r, a, b
        double  uu, uv, vv, wu, wv, D
        double s,t
        # anything that avoids division overflow.
        double SMALL_NUM = 0.00000001

    # Get triangle edge vectors
    subtract_points3d(&u, tri.B, tri.A)
    subtract_points3d(&v, tri.C, tri.A)

    # Get triangle plane normal.
    cross_product3d(&n, &u, &v)

    # Check for degenerated triangle.
    if n.x==0 and n.y==0 and n.z==0:
        return -1

    # Segment3D direction vector.
    subtract_points3d(&direction, seg.B, seg.A)

    #
    subtract_points3d(&w0, seg.A, tri.A)

    a = - dot_product3d(&n, &w0)
    b = dot_product3d(&n, &direction)

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
    point3d_plus_vector3d(I, seg.A, r, &direction)

    # is I inside tri?
    uu = dot_product3d(&u,&u)
    uv = dot_product3d(&u,&v)
    vv = dot_product3d(&v,&v)
    subtract_points3d(&w, I, tri.A)
    wu = dot_product3d(&w,&u)
    wv = dot_product3d(&w,&v)
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
