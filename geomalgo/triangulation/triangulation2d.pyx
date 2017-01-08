import numpy as np
import matplotlib.tri

from libc.math cimport fabs

from ..base2d cimport (
    CTriangle2D, CPoint2D, Triangle2D, Point2D, triangle2d_set,
    triangle2d_center, triangle2d_signed_area, triangle2d_gradx_grady_det,
    c_point2d_distance)

cdef class Triangulation2D:

    def __init__(Triangulation2D self, double[:] x, double[:] y, int[:,:] trivtx):
        self.NV = x.shape[0]
        self.NT = trivtx.shape[0]

        assert y.shape[0] == self.NV
        assert trivtx.shape[1] == 3

        self.x = x
        self.y = y
        self.trivtx = trivtx

        self.xcenter = None
        self.ycenter = None

        self.signed_area = None

        self.xmin = 0.
        self.xmax = 0.

        self.ymin = 0.
        self.ymax = 0.

        self.edge_min = 0.
        self.edge_max = 0.

        self.gradx = None
        self.grady = None
        self.det   = None

        self.ix_min = None
        self.ix_max = None
        self.iy_min = None
        self.iy_max = None

    cdef c_get(Triangulation2D self, int triangle_index, CTriangle2D* triangle):
        """
        Set 2D triangle point coordinates from its index in a triangulation

        Notes:
        ------

        Triangle points must be allocated before calling this function.
        """
        cdef:
            # Get points A, B and C indexes.
            int IA = self.trivtx[triangle_index, 0]
            int IB = self.trivtx[triangle_index, 1]
            int IC = self.trivtx[triangle_index, 2]

        # Set triangle point A coordinates
        triangle.A.x = self.x[IA]
        triangle.A.y = self.y[IA]

        # Set triangle point B coordinates
        triangle.B.x = self.x[IB]
        triangle.B.y = self.y[IB]

        # Set triangle point C coordinates
        triangle.C.x = self.x[IC]
        triangle.C.y = self.y[IC]


    def __getitem__(Triangulation2D self, int triangle_index):
        cdef:
            Triangle2D triangle = Triangle2D.__new__(Triangle2D)

        triangle.alloc_new()

        self.c_get(triangle_index, &triangle.ctri2d)
        triangle.index = triangle_index
        triangle.recompute()
        return triangle

    def compute_stat(self):
        cdef:
            int V, T
            CTriangle2D ABC
            CPoint2D A, B, C
            double ab, bc, ca

        # Check if the function has alread been called
        if self.edge_max != 0.:
            return

        triangle2d_set(&ABC, &A, &B, &C)

        self.xmin = self.x[0]
        self.xmax = self.x[0]

        self.ymin = self.y[0]
        self.ymax = self.y[0]

        for V in range(1, self.NV):
            self.xmin = min(self.xmin, self.x[V])
            self.xmax = max(self.xmax, self.x[V])

            self.ymin = min(self.ymin, self.y[V])
            self.ymax = max(self.ymax, self.y[V])

        # Initialize edge_min and edge_max
        self.c_get(0, &ABC)
        self.edge_min = self.edge_max = c_point2d_distance(&A, &B)

        for T in range(self.NT):
            self.c_get(T, &ABC)
            ab = c_point2d_distance(&A, &B)
            bc = c_point2d_distance(&B, &C)
            ca = c_point2d_distance(&C, &A)
            self.edge_min = min(self.edge_min, ab, bc, ca)
            self.edge_max = max(self.edge_max, ab, bc, ca)

    def allocate_locator(self):
        # Check if the function as already been called
        if self.ix_min is not None:
            return

        self.ix_min = np.empty(self.NT, dtype='int32')
        self.ix_max = np.empty(self.NT, dtype='int32')
        self.iy_min = np.empty(self.NT, dtype='int32')
        self.iy_max = np.empty(self.NT, dtype='int32')

    def compute_centers(Triangulation2D self):
        cdef:
            int T
            CTriangle2D ABC
            CPoint2D A, B, C, center

        if self.xcenter is not None:
            return

        self.xcenter = np.empty(self.NT, dtype='d')
        self.ycenter = np.empty(self.NT, dtype='d')

        triangle2d_set(&ABC, &A, &B, &C)

        for T in range(self.NT):
            self.c_get(T, &ABC)

            # Compute triangle center.
            triangle2d_center(&ABC, &center)
            self.xcenter[T] = center.x
            self.ycenter[T] = center.y

    def compute_signed_area(Triangulation2D self):
        cdef:
            int T
            CTriangle2D ABC
            CPoint2D A, B, C

        #Check if the function as already been called
        if self.signed_area is not None:
            return

        self.signed_area = np.empty(self.NT, dtype='d')

        triangle2d_set(&ABC, &A, &B, &C)

        for T in range(self.NT):
            self.c_get(T, &ABC)

            # Compute triangle area.
            self.signed_area[T] = triangle2d_signed_area(&ABC)

    def compute_interpolator(Triangulation2D self):
        cdef:
            int T
            CTriangle2D ABC
            CPoint2D A, B, C

        self.compute_signed_area()

        #Check if the function as already been called
        if self.gradx is not None:
            return

        self.gradx = np.empty((self.NT,3), dtype='d')
        self.grady = np.empty((self.NT,3), dtype='d')
        self.det   = np.empty((self.NT,3), dtype='d')

        triangle2d_set(&ABC, &A, &B, &C)

        for T in range(self.NT):
            self.c_get(T, &ABC)

            # Compute gradx, grady, det (for interpolations).
            triangle2d_gradx_grady_det(&ABC, fabs(self.signed_area[T]),
                                       &self.gradx[T,0], &self.grady[T,0],
                                       &self.det[T,0])

    def to_numpy(Triangulation2D self):
        return np.asarray(self.x), np.asarray(self.y), np.asarray(self.trivtx)

    def to_matplotlib(Triangulation2D self):
        return matplotlib.tri.Triangulation(self.x, self.y, self.trivtx)
