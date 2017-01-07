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
        # Used by TriangulationLocator
        int[:] ix_min, ix_max, iy_min, iy_max

    cdef c_get(Triangulation2D self, int I, CTriangle2D* T)
