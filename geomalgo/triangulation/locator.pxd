from .triangulation2d cimport Triangulation2D
from ..grid2d cimport Grid2D

cdef class TriangulationLocator:

    cdef public:
        Triangulation2D TG
        Grid2D grid

        double edge_width
        double edge_width_square

        int[:] celltri
        int[:] celltri_idx

    cpdef int search_points(TriangulationLocator self,
                            double[:] xpoints, double[:] ypoints,
                            int[:] triangles)
