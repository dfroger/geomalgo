import matplotlib.pyplot as plt
from matplotlib import colors
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import numpy as np


from libc.stdlib cimport malloc, free

from .point3d cimport subtract_points3d, point3d_plus_vector3d
from .vector3d cimport (CVector3D, dot_product3d, cross_product3d,
                        compute_norm3d)


# ============================================================================
# Structures
# ============================================================================


cdef CTriangle3D* new_triangle3d():
    return <CTriangle3D*> malloc(sizeof(CTriangle3D))

cdef void del_triangle3d(CTriangle3D* T):
    if T is not NULL:
        free(T)


# ============================================================================
# Computational functions
# ============================================================================


cdef double triangle3d_area(CTriangle3D* T):
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


cdef (double, double) triangle3d_parametric_equation(CTriangle3D* T, CPoint3D* P):
    # XXX should be optimized like triangle2d_gradx_grady_det
    # TODO: document barycentric coords: 1-s-t, s, t
    cdef:
        double s, t
        CVector3D u, v, w
        double uu, vv, uv, wv, wu
        double denum

    subtract_points3d(&u, T.B, T.A)
    subtract_points3d(&v, T.C, T.A)
    subtract_points3d(&w,   P, T.A)

    uu = dot_product3d(&u, &u)
    vv = dot_product3d(&v, &v)
    uv = dot_product3d(&u, &v)
    wv = dot_product3d(&w, &v)
    wu = dot_product3d(&w, &u)

    denum = uv**2 - uu*vv

    s = (uv*wv - vv*wu) / denum
    t = (uv*wu - uu*wv) / denum

    return s, t



# ============================================================================
# Python API
# ============================================================================


cdef class Triangle3D:

    property A:
        def __get__(self):
            return self.A
        def __set__(self, Point3D A):
            self.A = A
            # C points to Python.
            self.ctri3d.A = A.cpoint3d

    property B:
        def __get__(self):
            return self.B
        def __set__(self, Point3D B):
            self.B = B
            # C points to Python.
            self.ctri3d.B = B.cpoint3d

    property C:
        def __get__(self):
            return self.C
        def __set__(self, Point3D C):
            self.C = C
            # C points to Python.
            self.ctri3d.C = C.cpoint3d

    property area:
        def __get__(self):
            return triangle3d_area(&self.ctri3d)

    property center:
        def __get__(self):
            cdef:
                Point3D C = Point3D.__new__(Point3D)
            triangle3d_center(&self.ctri3d, C.cpoint3d)
            return C

    def __init__(self, Point3D A, Point3D B, Point3D C, index=0):
        self.A = A
        self.B = B
        self.C = C
        self.index = index

        # C points to Python.
        self.ctri3d.A = A.cpoint3d
        self.ctri3d.B = B.cpoint3d
        self.ctri3d.C = C.cpoint3d

    def symetric_point(Triangle3D self, Point3D P):
        cdef:
            Point3D S = Point3D.__new__(Point3D)
            CTriangle3D T
        T.A = self.A.cpoint3d
        T.B = self.B.cpoint3d
        T.C = self.C.cpoint3d
        compute_symetric_point3d(S.cpoint3d, &T, P.cpoint3d)
        return S

    def barycentric_coords(Triangle3D self, Point3D P):
        cdef:
            double s, t, a, b, c
        s, t = triangle3d_parametric_equation(&self.ctri3d, P.cpoint3d)
        return 1-s-t, s, t

    def plot(self, facecolor='b', alpha=0.2, edgecolor='k'):
        vtx = np.array([(P.x, P.y, P.z) for P in (self.A, self.B, self.C)])

        tri = Poly3DCollection([vtx], facecolors=colors.to_rgba(facecolor, alpha))
        tri.set_edgecolor(edgecolor)

        ax = plt.gca(projection='3d')
        ax.add_collection3d(tri)
