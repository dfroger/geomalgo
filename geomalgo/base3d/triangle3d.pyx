from libc.stdlib cimport malloc, free

from .point3d cimport subtract_points3d, point3d_plus_vector3d
from .vector3d cimport (CVector3D, dot_product3d, cross_product3d,
                        compute_norm3d)

cdef CTriangle3D* new_triangle3d():
    return <CTriangle3D*> malloc(sizeof(CTriangle3D))

cdef void del_triangle3d(CTriangle3D* T):
    if T is not NULL:
        free(T)

cdef double compute_area3d(CTriangle3D* T):
    """
    Compute the (positive) area of a 3D triangle.

    Implementation of http://geomalgorithms.com/a01-_area.html.
    """
    cdef:
        CVector3D v, w, z

    subtract_points3d(&v, T.B, T.A)
    subtract_points3d(&w, T.C, T.A)

    cross_product3d(&z, &v, &w)

    return 0.5 * compute_norm3d(&z)

cdef void compute_triangle_normal(CVector3D* normal, CTriangle3D* T):
    """
    Extracted from
    http://geomalgorithms.com/a06-_intersect-2.html#intersect3D_RayTriangle%28%29
    """
    cdef:
        CVector3D u
        CVector3D v

    # Get triangle edge vectors
    subtract_points3d(&u, T.B, T.A)
    subtract_points3d(&v, T.C, T.A)

    # Get triangle plane normal.
    cross_product3d(normal, &u, &v)

cdef void compute_symetric_point3d(CPoint3D* S, CTriangle3D* T, CPoint3D* P):
    """
    Adapted from a code that I don't know where it come from.

    To be improved.
    """
    cdef:
        CVector3D n
        CVector3D u
        double norm2, distance

    compute_triangle_normal(&n, T)
    norm2 = dot_product3d(&n, &n)

    subtract_points3d(&u, P, T.A)
    distance = dot_product3d(&u,&n)

    point3d_plus_vector3d(S, P, -2. * distance / norm2, &n)

cdef class Triangle3D:
            
    property area:
        """Compute and return area of the vector"""
        def __get__(self):
            cdef:
                CTriangle3D T
            T.A = self.A.cpoint3d
            T.B = self.B.cpoint3d
            T.C = self.C.cpoint3d
            return compute_area3d(&T)

    def __init__(self, Point3D A, Point3D B, Point3D C, index=0):
        self.A = A
        self.B = B
        self.C = C
        self.index = index

    def symetric_point(Triangle3D self, Point3D P):
        cdef:
            Point3D S = Point3D.__new__(Point3D)
            CTriangle3D T
        T.A = self.A.cpoint3d
        T.B = self.B.cpoint3d
        T.C = self.C.cpoint3d
        compute_symetric_point3d(S.cpoint3d, &T, P.cpoint3d)
        return S
