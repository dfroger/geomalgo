"""
Grid2D is a simple 2D cartesian structured mesh.

It supports finding which cell contains a given 2D point.

"""

import numpy as np

from ..base2d cimport Point2D
from ..triangulation cimport Triangulation2D


cpdef (int, int) compute_row_col(int index, int nx):
    cdef:
        int ix, iy
    ix = index  % nx
    iy = index // nx
    return ix, iy


cdef class Grid2D:

    def __init__(Grid2D self,
                 double xmin, double xmax, int nx,
                 double ymin, double ymax, int ny):

        self.xmin = xmin
        self.xmax = xmax
        self.nx = nx
        self.dx = (xmax - xmin) / nx

        self.ymin = ymin
        self.ymax = ymax
        self.ny = ny
        self.dy = (ymax - ymin) / ny

    @staticmethod
    def from_triangulation(Triangulation2D TG, int nx, int ny,
                           double edge_width):
        x = np.asarray(TG.x)
        y = np.asarray(TG.y)

        xmin, xmax = x.min(), x.max()
        ymin, ymax = y.min(), y.max()

        xmin -= edge_width
        ymin -= edge_width

        xmax += edge_width
        ymax += edge_width

        return Grid2D(xmin, xmax, nx, ymin, ymax, ny)

    cdef void c_find_cell(Grid2D self, Cell2D cell, CPoint2D* P):
        cell.ix = coord_to_index(P.x, self.xmin, self.dx)
        cell.iy = coord_to_index(P.y, self.ymin, self.dy)

    def find_cell(Grid2D self, Point2D P):
        cdef:
            Cell2D cell = Cell2D()
        self.c_find_cell(cell, P.cpoint2d)
        cell.index = compute_index(self.nx, cell.ix, cell.iy)
        return cell


cdef class Cell2D:
    pass
