from ..grid2d cimport Grid2D
from .triangulation2d cimport Triangulation2D

cpdef build_triangle_to_cell(
    int[:] ix_min, int[:] ix_max,
    int[:] iy_min, int[:] iy_max,
    Triangulation2D TG, Grid2D grid2d,
    double triangle_border)


cpdef build_cell_to_triangle(
    int[:] ix_min, int[:] ix_max,
    int[:] iy_min, int[:] iy_max)
