"""
For a given cell, find all triangle that overlap the cells.

Each triangle is associated with a range of cells from ix_min to ix_max and
from iy_min to iy_max. Some cells may not overlap with the triangle, but this
make is simpler and less error prone. To optimize, we would need a method to
check whether a triangle and a cell overlap.

"""

import numpy as np

from ..base2d cimport (
    BoundingBox, CTriangle2D, CPoint2D, triangle2d_set,
    triangle2d_includes_point2d, triangle2d_on_edges
)
from ..grid2d cimport Cell2D, compute_index
from .util import compute_bounding_box, compute_edge_min_max


DEF IX_MIN = 0
DEF IX_MAX = 1
DEF IY_MIN = 2
DEF IY_MAX = 3

DEF OUT_IDX = -1


# Grid is larger than bounding box with 2*edge_width, which ensure that points
# near boundary are found in cells (0, nx-1, ny-1), and not (-1, nx, ny).
#
#    ggggggggggggggggggggggggggg
#    g           ^             g
#    g           | dist        g
#    g           v             g   b = bounding box
#    g      bbbbbbbbbbbbb      g   g = grid
#    g      b           b      g
#    g<---->b           b<---->g   dist >= 2*edge_width
#    g dist b           b dist g
#    g      b           b      g
#    g      bbbbbbbbbbbbb      g
#    g           ^             g
#    g           | dist        g
#    g           v             g
#    ggggggggggggggggggggggggggg


def choose_edge_width(edge_min):
    return edge_min * 1.E-07


def choose_bb_grid_distance(edge_width):
    return edge_width * 2


def build_grid(Triangulation2D TG, int nx, int ny, double dist=-1):
    bb = compute_bounding_box(TG)

    if dist < 0:
        edge_min, edge_max = compute_edge_min_max(TG)
        edge_width = choose_edge_width(edge_min)
        dist = choose_bb_grid_distance(edge_width)

    return Grid2D(bb.xmin-dist, bb.xmax+dist, nx,
                  bb.ymin-dist, bb.ymax+dist, ny)


def check_grid(Grid2D grid, BoundingBox bb, edge_width):
    dist = choose_bb_grid_distance(edge_width)

    msg = ('grid must be at distance 2*edge_width={} from the triangulation'
           ' bounding box, but {{}} is at a distance: {{}}'
           .format(dist))

    dist *= 0.9  # tolerance

    if bb.xmin - grid.xmin < dist:
        msg = msg.format('xmin', bb.xmin - grid.xmin)

    elif bb.ymin - grid.ymin < dist:
        msg = msg.format('ymin', bb.ymin - grid.ymin)

    elif grid.xmax - bb.xmax < dist:
        msg = msg.format('xmax', grid.xmax - bb.xmax)

    elif grid.ymax - bb.ymax < dist:
        msg = msg.format('ymax', grid.ymax - bb.ymax)

    else:
        return

    raise ValueError(msg)


def build_triangle_to_cell(int[:,:] bounds, Triangulation2D TG, Grid2D grid,
                           double edge_width):

    cdef:
        int T
        int ix, iy
        CTriangle2D ABC
        CPoint2D A, B, C, P
        Cell2D cell = Cell2D()

    triangle2d_set(&ABC, &A, &B, &C)

    for T in range(TG.NT):
        TG.get(T, &ABC)

        #    C--------------C--------------C
        #    |              |              |
        #    |          C---B---D          |
        #    |            \ | /            |
        #    |    cell 0    A    cell 1    |
        #    |              |              |
        #    |              |              |
        #    C--------------C--------------C
        #
        # If a point is on [AB], we don't know if it will be detected in
        # triangle ABC or ADB, so we map each triangle to cells containing
        # triangle points and cells at a distance edge_width of points.
        #
        # The grid is around the triangulation at a distance 2*edge_width (see
        # utils.build_grid), so it is guaranted that ix is not -1 or nx
        # (same for y).

        # Cell blocks south-west point
        P.x = min(A.x, B.x, C.x) - edge_width
        P.y = min(A.y, B.y, C.y) - edge_width
        grid.c_find_cell(cell, &P)
        bounds[T,IX_MIN] = cell.ix
        bounds[T,IY_MIN] = cell.iy

        # Cell blocks north-east point
        P.x = max(A.x, B.x, C.x) + edge_width
        P.y = max(A.y, B.y, C.y) + edge_width
        grid.c_find_cell(cell, &P)
        bounds[T,IX_MAX] = cell.ix+1
        bounds[T,IY_MAX] = cell.iy+1


def build_cell_to_triangle(int[:,:] bounds, int nx, int ny):

    cdef:
        #Number of triangles of a cell.
        int[:] celltri
        int[:] cell_triangles_idx
        int[:] count = np.zeros(nx*ny, dtype='int32')
        int T, NT = bounds.shape[0]
        int ix, iy, cell_index, offset
        int total = 0

    # Count how much triangles each cell has.
    for T in range(NT):
        for iy in range(bounds[T,IY_MIN], bounds[T,IY_MAX]):
            for ix in range(bounds[T,IX_MIN], bounds[T,IX_MAX]):
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
        for iy in range(bounds[T,IY_MIN], bounds[T,IY_MAX]):
            for ix in range(bounds[T,IX_MIN], bounds[T,IX_MAX]):
                cell_index = compute_index(nx, ix, iy)
                offset = offsets[cell_index]
                celltri[offset] = T
                offsets[cell_index] += 1

    return np.asarray(celltri), np.asarray(celltri_idx)


cdef class TriangulationLocator:
    def __init__(TriangulationLocator self, Triangulation2D TG,
                 Grid2D grid=None, double edge_width=-1,
                 int[:,:] bounds=None):

        cdef:
            double dist, edge_min, edge_max

        bb = compute_bounding_box(TG)
        edge_min, edge_max = compute_edge_min_max(TG)

        if edge_width < 0:
            edge_width = choose_edge_width(edge_min)

        if grid is None:
            nx = max(1, int((bb.xmax - bb.xmin) / (edge_max * 10)))
            ny = max(1, int((bb.ymax - bb.ymin) / (edge_max * 10)))
            dist = choose_bb_grid_distance(edge_width)
            grid = build_grid(TG, nx, ny, dist)
        else:
            check_grid(grid, bb, edge_width)

        self.grid = grid

        self.TG = TG
        self.edge_width = edge_width
        self.edge_width_square = edge_width**2

        if bounds is None:
            bounds = np.empty((TG.NT, 4), dtype='int32')
        else:
            assert bounds.shape == (TG.NT, 4)
            bounds = bounds

        build_triangle_to_cell(bounds, TG, self.grid, edge_width)

        self.celltri, self.celltri_idx = build_cell_to_triangle(
                                             bounds, grid.nx, grid.ny)

    cpdef int[:] search_points(TriangulationLocator self,
                               double[:] xpoints, double[:] ypoints,
                               int[:] triangles=None):
        cdef:
            int IP, IT, IT0, IT1, T, cell_index
            int NP = xpoints.shape[0]
            Cell2D cell = Cell2D()
            CTriangle2D ABC
            CPoint2D A, B, C, P

        if triangles is None:
            triangles = np.empty(NP, dtype='int32')

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
                triangles[IP] = OUT_IDX
                continue

            cell_index = compute_index(self.grid.nx, cell.ix, cell.iy)

            # Loop on cell triangles.
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

                    if triangle2d_on_edges(&ABC, &P, self.edge_width_square) != -1:
                        triangles[IP] = T
                        break

                else:
                    triangles[IP] = OUT_IDX

        return triangles

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
