from libc.stdlib cimport malloc, free

from .point cimport subtract_points, point_plus_vector
from .vector cimport CVector, dot_product, cross_product, compute_norm

cdef CTriangle* new_triangle():
    return <CTriangle*> malloc(sizeof(CTriangle))

cdef void del_triangle(CTriangle* ctriangle):
    if ctriangle is not NULL:
        free(ctriangle)

cdef double compute_area(CTriangle* triangle):
    """
    Compute the (positive) area of a 3D triangle.

    Implementation of http://geomalgorithms.com/a01-_area.html.
    """
    cdef:
        CVector v, w, z

    subtract_points(&v, triangle.B, triangle.A)
    subtract_points(&w, triangle.C, triangle.A)

    cross_product(&z, &v, &w)

    return 0.5 * compute_norm(&z)

cdef void compute_triangle_normal(CVector* normal, CTriangle* triangle):
    """
    Extracted from
    http://geomalgorithms.com/a06-_intersect-2.html#intersect3D_RayTriangle%28%29
    """
    cdef:
        CVector u
        CVector v

    # Get triangle edge vectors
    subtract_points(&u, triangle.B, triangle.A)
    subtract_points(&v, triangle.C, triangle.A)

    # Get triangle plane normal.
    cross_product(normal, &u, &v)

cdef void compute_symetric_point(CPoint* S, CTriangle* triangle, CPoint* P):
    """
    Adapted from a code that I don't know where it come from.

    To be improved.
    """
    cdef:
        CVector n
        CVector u
        double norm2, distance

    compute_triangle_normal(&n, triangle)
    norm2 = dot_product(&n, &n)

    subtract_points(&u, P, triangle.A)
    distance = dot_product(&u,&n)

    point_plus_vector(S, P, -2. * distance / norm2, &n)

cdef class Triangle:
            
    property area:
        """Compute and return area of the vector"""
        def __get__(self):
            cdef:
                CTriangle ctriangle
            ctriangle.A = self.A.cpoint
            ctriangle.B = self.B.cpoint
            ctriangle.C = self.C.cpoint
            return compute_area(&ctriangle)

    def __init__(self, Point A, Point B, Point C):
        self.A = A
        self.B = B
        self.C = C

    def symetric_point(Triangle self, Point P):
        cdef:
            Point S = Point.__new__(Point)
            CTriangle triangle
        triangle.A = self.A.cpoint
        triangle.B = self.B.cpoint
        triangle.C = self.C.cpoint
        compute_symetric_point(S.cpoint, &triangle, P.cpoint)
        return S
