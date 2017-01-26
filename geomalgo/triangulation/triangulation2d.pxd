from ..base2d cimport CTriangle2D

cdef class Triangulation2D:

    cdef public:
        int NV
        int NT
        double[:] x
        double[:] y
        int[:,:] trivtx

        double[:] xcenter
        double[:] ycenter
        double[:] signed_area

        # stats
        double xmin
        double xmax

        double ymin
        double ymax

        double edge_min
        double edge_max

        # Used by TriangulationLocator
        int[:] ix_min, ix_max, iy_min, iy_max

        # Used by TriangleInterpolator
        double[:,:] gradx, grady, det

    cdef get(Triangulation2D self, int I, CTriangle2D* T)
