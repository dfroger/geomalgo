"""
Grid2D is a simple 2D cartesian structured mesh.

It supports finding which cell contains a given 2D point.

"""

import numpy as np
import matplotlib.pyplot as plt

from ..base2d cimport Point2D


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
        self.x, self.dx = np.linspace(xmin, xmax, nx+1, retstep=True)

        self.ymin = ymin
        self.ymax = ymax
        self.ny = ny
        self.y, self.dy = np.linspace(ymin, ymax, ny+1, retstep=True)

    cdef void c_find_cell(Grid2D self, Cell2D cell, CPoint2D* P):
        cell.ix = coord_to_index(P.x, self.xmin, self.dx)
        cell.iy = coord_to_index(P.y, self.ymin, self.dy)

    def find_cell(Grid2D self, Point2D P):
        cdef:
            Cell2D cell = Cell2D()
        self.c_find_cell(cell, P.cpoint2d)
        cell.index = compute_index(self.nx, cell.ix, cell.iy)
        return cell

    def plot(self, color='blue', lw=2):
        # Plot vertical lines.
        for x in self.x:
            plt.plot([x, x], [self.ymin, self.ymax], color=color, lw=lw)
        # Plot horizonal lines
        for y in self.y:
            plt.plot([self.xmin, self.xmax], [y, y], color=color, lw=lw)

cdef class Cell2D:
    pass
