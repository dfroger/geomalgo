"""
For a given cell, find all triangle that overlap the cells.

Each triangle is associated with a range of cells from ix_min to ix_max and
from iy_min to iy_max. Some cells may not overlap with the triangle, but this
make is simpler and less error prone. To optimize, we would need a method to
check whether a triangle and a cell overlap.

"""

import numpy as np

from ..base2d cimport CTriangle2D, CPoint2D, triangle2d_set
from ..grid2d cimport Cell2D, Grid2D, compute_index
from .triangulation2d cimport Triangulation2D

def build_triangle_to_cell(
    int[:] ix_min, int[:] ix_max,
    int[:] iy_min, int[:] iy_max,
    Triangulation2D TG, Grid2D grid,
    double edge_width):

    """
    Parameters
    ----------
    trivtx: int[NT, 3]
        Triangle vertices.

    iy_min: int[NT]
        Cells block of a triangle

    ix_min: int[NT]
        Cells block of a triangle
    """

    cdef:
        int T
        int ix, iy
        CTriangle2D ABC
        CPoint2D A, B, C, P
        Cell2D cell = Cell2D()

    triangle2d_set(&ABC, &A, &B, &C)

    for T in range(TG.NT):
        TG.c_get(T, &ABC)

        # Cell blocks south-west point
        P.x = min(A.x, B.x, C.x) - edge_width
        P.y = min(A.y, B.y, C.y) - edge_width
        grid.c_find_cell(cell, &P)
        ix_min[T] = cell.ix
        iy_min[T] = cell.iy

        # Cell blocks north-east point
        P.x = max(A.x, B.x, C.x) + edge_width
        P.y = max(A.y, B.y, C.y) + edge_width
        grid.c_find_cell(cell, &P)
        ix_max[T] = cell.ix
        iy_max[T] = cell.iy


def build_cell_to_triangle(
    int[:] ix_min, int[:] ix_max,
    int[:] iy_min, int[:] iy_max,
    int nx, int ny):

    cdef:
        #Number of triangles of a cell.
        int[:] celltri
        int[:] cell_triangles_idx
        int[:] count = np.zeros(nx*ny, dtype='int32')
        int T, NT = ix_min.shape[0]
        int ix, iy, cell_index, offset
        int total = 0

    # Count how much triangles each cell has.
    for T in range(NT):
        for iy in range(iy_min[T], iy_max[T] + 1):
            for ix in range(ix_min[T], ix_max[T] + 1):
                cell_index = compute_index(nx, ix, iy)
                count[cell_index] += 1
                total += 1

    # Allocate arrays
    celltri = np.empty(total, dtype='int32')
    celltri_idx = np.empty(nx*ny + 1, dtype='int32')
    offsets = np.empty(nx*ny, dtype='int32')

    # Set celltri_idx and initialize offsets.
    celltri_idx[0] = 0
    for cell_index in range(nx*ny):
        celltri_idx[cell_index+1] = celltri_idx[cell_index] + count[cell_index]
        offsets[cell_index] = celltri_idx[cell_index]

    # Set celltri
    for T in range(NT):
        for iy in range(iy_min[T], iy_max[T] + 1):
            for ix in range(ix_min[T], ix_max[T] + 1):
                cell_index = compute_index(nx, ix, iy)
                offset = offsets[cell_index]
                celltri[offset] = T
                offsets[cell_index] += 1

    return np.asarray(celltri), np.asarray(celltri_idx)



# **************************************************
# Example with triangle edges greater than cell side
# **************************************************
#
# Legend:
#    A B C D position of triangle vertices
#    +       position of cell vertices
#    :       vertical cell edges
#    .       horizontal cell edges
#    - \     triangle edges
#
#   iy
#      +...+...+...+...+...+...+...+...+...+
#    6 :   :   :   :   :   :   :   :   :   :
#      +...+...+...+...+...+...+...+...+...+
#    5 :   :       :C---------------D  :   :
#      +...+...+.../.\.+...+...+.../...+...+
#    4 :   :   :  /:  \:   : X :  /:   :   :
#      +...+...+./.+...\...+...+./.+...+...+
#    3 :   :   :/  :   :\  :   :/  :   :   :
#      +...+.../...+...+.\.+.../...+...+...+
#    2 :   :  /:   :   :  \:  /:   :   :   :
#      +...+./.+...+...+...\./.+...+...+...+
#    1 :   :A---------------B  :   :   :   :
#      +...+...+...+...+...+...+...+...+...+
#    0 :   :   :   :   :   :   :   :   :   :
#      +...+...+...+...+...+...+...+...+...+
#        0   1   2   3   4   5   6   7   8  ix
#
#    When looping on triangle ABC, the 25 cells delimited by iy=1...5 and
#    ix=1...5 are associated to triangle ABC.
#
#    When looping on triangle BCD, the 25 cells delimited by iy=1...5 and
#    ix=3...7 are associated to triangle BCD.
#
#    So, when searching in which triangle the point X is, it will be searched
#    in both ABC and BCD.
#
# ***********************************************
# Example with triangle edges less than cell side
# ***********************************************

# Each triangle is to be search in 1, 2, 3 or 4 cells. There are
# 6 different cases, drawn bellow.
#
# Legend:
#    A, B, C  position of triangle vertices.
#    +        position of cell vertices
#    -        horizontal cell edges
#    |        vertical cell edges
#    x        cell edge and triangle edge intersections
#    # ~      cell that do not overlap with triangles
#
# A, B and C all in the same cell.
# ================================
#
#       0) 1 cell
#    +------+------+
#    | A  C |######|
#    |      |######|
#    | B    |######|
#    +------+------+
#    |######|######|
#    |######|######|
#    |######|######|
#    +------+------+
#
# A and B in one cell, C in another.
# ==================================
#
#       1) 2 cells        2) 3 cells         3) 4 cells
#    +------+------+    +------+------+    +------+------+
#    |   A  x   C  |    |    A |      |    |    A |      |
#    |      x      |    |    B x      |    |      x      |
#    |   B  |      |    |      x      |    | B    |      |
#    +------+------+    +------+--xx--+    +---x--+-x----+
#    |######|######|    |~~~~~~|    C |    |      x      |
#    |######|######|    |~~~~~~|      |    |      |   C  |
#    |######|######|    |~~~~~~|      |    |      |      |
#    +------+------+    +------+------+    +------+------+
#
# A, B and C all in different cells.
# ==================================
#
#      4) 3 cells         5) 4 cells
#    +------+------+    +------+------+
#    | A    x C    |    |      |      |
#    |      x      |    |   A  x    C |
#    |      |      |    |      |      |
#    +-x--x-+------+    +---x--+-x----+
#    |      |~~~~~~|    |      x      |
#    | B    |~~~~~~|    |      |      |
#    |      |~~~~~~|    |   B  |      |
#    +------+------+    +------+------+
