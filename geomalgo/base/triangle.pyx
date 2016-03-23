from libc.stdlib cimport malloc, free

from .point cimport subtract_points, point_plus_vector
from .vector cimport CVector, dot_product, cross_product
from ..work cimport work

cdef CTriangle* new_triangle():
    return <CTriangle*> malloc(sizeof(CTriangle))

cdef void del_triangle(CTriangle* ctriangle):
    if ctriangle is not NULL:
        free(ctriangle)

cdef void compute_triangle_normal(CVector* normal, CTriangle* triangle):
    """
    Extracted from
    http://geomalgorithms.com/a06-_intersect-2.html#intersect3D_RayTriangle%28%29
    """
    cdef:
        CVector* u = &work.vector10
        CVector* v = &work.vector11

    # Get triangle edge vectors
    subtract_points(u, triangle.B, triangle.A)
    subtract_points(v, triangle.C, triangle.A)

    # Get triangle plane normal.
    cross_product(normal, u, v)

cdef void compute_symetric_point(CPoint* S, CTriangle* triangle, CPoint* P):
    """
    Adapted from a code that I don't know where it come from.

    To be improved.
    """
    cdef:
        CVector* n = &work.vector0
        CVector* u = &work.vector1
        double norm, distance

    compute_triangle_normal(n, triangle)
    norm = dot_product(n, n)

    subtract_points(u, P, triangle.A)
    distance = dot_product(u,n)

    point_plus_vector(S, P, -2. * distance / norm, n)

cdef class Triangle:

    def __init__(self, Point A, Point B, Point C):
        self.A = A
        self.B = B
        self.C = C

    def symetric_point(Triangle self, Point P):
        cdef:
            Point S = Point.__new__(Point)
            CTriangle* triangle = &work.triangle100
        triangle.A = self.A.cpoint
        triangle.B = self.B.cpoint
        triangle.C = self.C.cpoint
        compute_symetric_point(S.cpoint, triangle, P.cpoint)
        return S
