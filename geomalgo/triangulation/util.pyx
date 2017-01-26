import numpy as np
from libc.math cimport fabs

from .triangulation2d cimport Triangulation2D

from ..base2d import BoundingBox

from ..base2d cimport (
    CTriangle2D, CPoint2D, triangle2d_set, triangle2d_center,
    triangle2d_signed_area, triangle2d_gradx_grady_det, point2d_distance)


def compute_centers(Triangulation2D TG):
    # TODO: optinal output arrays
    cdef:
        int T
        CTriangle2D ABC
        CPoint2D A, B, C, O  # O is the center of triangle ABC.
        double[:] xcenter = np.empty(TG.NT, dtype='d')
        double[:] ycenter = np.empty(TG.NT, dtype='d')

    triangle2d_set(&ABC, &A, &B, &C)

    for T in range(TG.NT):
        TG.get(T, &ABC)

        # Compute triangle center O.
        triangle2d_center(&ABC, &O)
        xcenter[T] = O.x
        ycenter[T] = O.y

    return np.asarray(xcenter), np.asarray(ycenter)


def compute_bounding_box(Triangulation2D TG):
    cdef:
        int V
        double xmin, xmax
        double ymin, ymax

    # Initialize xmin, xmax, ymin, ymax
    xmin = xmax = TG.x[0]
    ymin = ymax = TG.y[0]

    for V in range(1, TG.NV):
        xmin = min(xmin, TG.x[V])
        xmax = max(xmax, TG.x[V])

        ymin = min(ymin, TG.y[V])
        ymax = max(ymax, TG.y[V])

    return BoundingBox(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax)


def compute_edge_min_max(Triangulation2D TG):
    cdef:
        int T
        CTriangle2D ABC
        CPoint2D A, B, C
        double ab, bc, ca
        double edge_min, edge_max

    triangle2d_set(&ABC, &A, &B, &C)

    # Initialize edge_min and edge_max
    TG.get(0, &ABC)
    edge_min = edge_max = point2d_distance(&A, &B)

    for T in range(TG.NT):
        TG.get(T, &ABC)
        ab = point2d_distance(&A, &B)
        bc = point2d_distance(&B, &C)
        ca = point2d_distance(&C, &A)
        edge_min = min(edge_min, ab, bc, ca)
        edge_max = max(edge_max, ab, bc, ca)

    return edge_min, edge_max


def compute_signed_area(Triangulation2D TG):
    cdef:
        int T
        CTriangle2D ABC
        CPoint2D A, B, C
        double[:] signed_area = np.empty(TG.NT, dtype='d')

    triangle2d_set(&ABC, &A, &B, &C)

    for T in range(TG.NT):
        TG.get(T, &ABC)
        signed_area[T] = triangle2d_signed_area(&ABC)

    return np.asarray(signed_area)


def compute_interpolator(Triangulation2D TG, double[:] signed_area):
    # Compute gradx, grady, det (for interpolations).

    cdef:
        int T
        CTriangle2D ABC
        CPoint2D A, B, C
        double[:,:] gradx = np.empty((TG.NT,3), dtype='d')
        double[:,:] grady = np.empty((TG.NT,3), dtype='d')
        double[:,:] det   = np.empty((TG.NT,3), dtype='d')

    triangle2d_set(&ABC, &A, &B, &C)

    for T in range(TG.NT):
        TG.get(T, &ABC)
        triangle2d_gradx_grady_det(&ABC, fabs(signed_area[T]),
                                   &gradx[T,0], &grady[T,0], &det[T,0])

    return np.asarray(gradx), np.asarray(grady), np.asarray(det)
