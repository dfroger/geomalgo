from .triangulation2d cimport Triangulation2D
from .locator cimport TriangulationLocator

cdef class TriangulationInterpolator:
    """
    Interpolate data from triangle vertices to points.

    """

    cdef public:
        TriangulationLocator locator

        Triangulation2D TG

        int NP

        # Point localization.
        int[:] triangles

        # Interpolation factors
        double[:,:] factors

    cpdef int set_points(TriangulationInterpolator self,
                         double[:] xpoints, double[:] ypoints)

    cpdef void interpolate(self, double[:] tridata, double[:] pointdata)
