"""
For a given cell, find all triangle that overlap the cells.

Each triangle is associated with a range of cells from ix_min to ix_max and
from iy_min to iy_max. Some cells may not overlap with the triangle, but this
make is simpler and less error prone. To optimize, we would need a method to
check whether a triangle and a cell overlap.

"""

import numpy as np

from ..base2d cimport (
    CTriangle2D, CPoint2D, triangle2d_set, triangle2d_includes_point2d,
    triangle2d_on_edges
)
from ..grid2d cimport Cell2D, compute_index

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
        TG.get(T, &ABC)

        # In the schema, grid is aligned with
        # vertical and horitonzal triangle edges.
        #
        # triangles: s, t, u, v
        # cells: a, b, c, d
        #
        # We want for example triangle t to be associated
        # not just with cell a, but also with cell b.
        # This way, if a point on edge pq is detected to
        # be in cell b, it will be searched in triangle t.
        #
        # The same apply for triangle u and cells c and d, etc.
        #
        # This is done wy adding edge_width to triangle vertices
        # coordiante when search the cell ranges of a triangle.
        #
        # However, for triangle s, we don't want ix_min to be -1, or
        # for triangle v, we don't want ix_max to be 4, etc.
        #                       iy
        # +----+----+----+----+
        # | \  | \  | \  | \  |
        # |  \ |  \ |  \ |  \ | 2
        # +----q----+----+----+
        # |s\ t|  hole   |u\ v|
        # |a \ | b    c  |  \d| 1
        # +----p----+----+----+
        # | \  | \  | \  | \  |
        # |  \ |  \ |  \ |  \ | 0
        # +----+----+----+----+
        #   0     1   2    3     ix

        # Cell blocks south-west point
        P.x = min(A.x, B.x, C.x) - edge_width
        P.y = min(A.y, B.y, C.y) - edge_width
        grid.c_find_cell(cell, &P)
        ix_min[T] = max(cell.ix, 0)
        iy_min[T] = max(cell.iy, 0)

        # Cell blocks north-east point
        P.x = max(A.x, B.x, C.x) + edge_width
        P.y = max(A.y, B.y, C.y) + edge_width
        grid.c_find_cell(cell, &P)
        ix_max[T] = min(cell.ix+1, grid.nx)
        iy_max[T] = min(cell.iy+1, grid.ny)


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
        for iy in range(iy_min[T], iy_max[T]):
            for ix in range(ix_min[T], ix_max[T]):
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
        for iy in range(iy_min[T], iy_max[T]):
            for ix in range(ix_min[T], ix_max[T]):
                cell_index = compute_index(nx, ix, iy)
                offset = offsets[cell_index]
                celltri[offset] = T
                offsets[cell_index] += 1

    return np.asarray(celltri), np.asarray(celltri_idx)


cdef class TriangulationLocator:
    """
    Note: Use TG.ix_min and others to store intermediate results (allocate
    them it not already).

    """

    def __init__(TriangulationLocator self, Triangulation2D TG,
                 int nx=0, int ny=0, double edge_width=-1):

        if nx==0 or ny==0 or edge_width < 0:
            TG.compute_stat()

        if nx == 0:
            nx = max(1, int((TG.xmax - TG.xmin) / (TG.edge_max * 10)))

        if ny == 0:
            ny = max(1, int((TG.ymax - TG.ymin) / (TG.edge_max * 10)))

        if edge_width < 0:
            edge_width = TG.edge_min * 1.E-07

        self.TG = TG
        self.edge_width = edge_width
        self.edge_width_square = edge_width**2

        TG.allocate_locator()
        self.grid = Grid2D.from_triangulation(TG, nx, ny)

        build_triangle_to_cell(TG.ix_min, TG.ix_max,
                               TG.iy_min, TG.iy_max,
                               TG, self.grid, edge_width)

        self.celltri, self.celltri_idx = build_cell_to_triangle(
                                             TG.ix_min, TG.ix_max,
                                             TG.iy_min, TG.iy_max,
                                             nx, ny)

    cpdef int search_points(TriangulationLocator self,
                            double[:] xpoints, double[:] ypoints,
                            int[:] triangles):
        cdef:
            int IP, IT, IT0, IT1, T, cell_index
            int NP = xpoints.shape[0]
            Cell2D cell = Cell2D()
            CTriangle2D ABC
            CPoint2D A, B, C, P

            # Number of points out of the triangulation
            int nout = 0

        triangle2d_set(&ABC, &A, &B, &C)

        for IP in range(NP):
            # Extract point.
            P.x = xpoints[IP]
            P.y = ypoints[IP]

            # Find cell.
            self.grid.c_find_cell(cell, &P)

            # Check if cell is in grid.
            if not 0 <= cell.ix < self.grid.nx or \
               not 0 <= cell.iy < self.grid.ny:
                triangles[IP] = -1
                nout += 1
                continue

            cell_index = compute_index(self.grid.nx, cell.ix, cell.iy)

            # Loop on cell triangles.
            edge_width = 0  # don't check triangles edges for now.
            IT0 = self.celltri_idx[cell_index]
            IT1 = self.celltri_idx[cell_index+1]
            for IT in range(IT0, IT1):
                T = self.celltri[IT]
                self.TG.get(T, &ABC)

                # Check if triangle contains point.
                if triangle2d_includes_point2d(&ABC, &P, self.edge_width_square):
                    triangles[IP] = T
                    break

            else:
                # Not found inside triangles, check if point is on triangle edges.
                for IT in range(IT0, IT1):
                    T = self.celltri[IT]
                    self.TG.get(T, &ABC)

                    if triangle2d_on_edges(&ABC, &P, edge_width) != -1:
                        triangles[IP] = T
                        break

                else:
                    # Point is not on triangulation
                    nout += 1
                    triangles[IP] = -1

        return nout

    def cell_to_triangles(TriangulationLocator self, int ix, int iy):
        cdef:
            int cell_index
            int IT, IT0, IT1

        cell_index = compute_index(self.grid.nx, ix, iy)

        IT0 = self.celltri_idx[cell_index]
        IT1 = self.celltri_idx[cell_index+1]

        return {self.celltri[IT] for IT in range(IT0, IT1)}


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
