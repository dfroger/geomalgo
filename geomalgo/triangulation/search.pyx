"""
For a given cell, find all triangle that overlap the cells.

Each triangle is associated with a range of cells from ix_min to ix_max and
from iy_min to iy_max. Some cells may not overlap with the triangle, but this
make is simpler and less error prone. To optimize, we whould need a method to
check whether a triangle and a cell overlap.

"""

from ..base2d cimport CTriangle2D, CPoint2D, triangle2d_set
from ..grid2d cimport Cell2D

cpdef build_triangle_to_cell(
    int[:] ix_min, int[:] ix_max,
    int[:] iy_min, int[:] iy_max,
    Triangulation2D TG, Grid2D grid,
    double triangle_border):

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
        P.x = min(A.x, B.x, C.x) - triangle_border
        P.y = min(A.y, B.y, C.y) - triangle_border
        grid.c_find_cell(cell, &P)
        ix_min[T] = cell.ix
        iy_min[T] = cell.iy

        # Cell blocks north-east point
        P.x = max(A.x, B.x, C.x) + triangle_border
        P.y = max(A.y, B.y, C.y) + triangle_border
        grid.c_find_cell(cell, &P)
        ix_max[T] = cell.ix
        iy_max[T] = cell.iy


cpdef build_cell_to_triangle(
    int[:] ix_min, int[:] ix_max,
    int[:] iy_min, int[:] iy_max):
    pass

    #cdef:
        #count: int[NX*NY]
        #Number of triangles of a cell. Must be initialized to zero.

    #for iy in range(iy_min[T], iy_min[T]):
        #for ix in range(ix_min[T], ix_max[T]):
            #cell_index = compute_index(nx, ix, iy)
            #count[cell_index] += 1
