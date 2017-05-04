import numpy as np
import matplotlib.tri

from ..base2d cimport CTriangle2D, Triangle2D


cdef class Triangulation2D:

    def __init__(Triangulation2D self, double[:] x, double[:] y, int[:,:] trivtx):
        nx = x.shape[0]
        ny = y.shape[0]

        if nx != ny:
            raise ValueError(
                'Vector x and y must have the same length, but got '
                '{} and {}'
                .format(nx, ny)
            )

        if trivtx.shape[1] != 3:
            raise ValueError(
                'trivtx must be an array of shape (NT, 3), '
                'but got: ({}, {})'
                .format(trivtx.shape[0], trivtx.shape[1])
            )

        self.NV = x.shape[0]
        self.NT = trivtx.shape[0]

        self.x = x
        self.y = y
        self.trivtx = trivtx

    cdef void get(Triangulation2D self, int triangle_index, CTriangle2D* triangle):
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

        self.get(triangle_index, &triangle.ctri2d)
        triangle.index = triangle_index
        triangle.recompute()
        return triangle


    def to_numpy(Triangulation2D self):
        return np.asarray(self.x), np.asarray(self.y), np.asarray(self.trivtx)


    def to_matplotlib(Triangulation2D self):
        return matplotlib.tri.Triangulation(self.x, self.y, self.trivtx)
