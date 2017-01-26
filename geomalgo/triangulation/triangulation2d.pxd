from ..base2d cimport CTriangle2D

cdef class Triangulation2D:

    cdef public:
        int NV
        int NT
        double[:] x
        double[:] y
        int[:,:] trivtx

    cdef get(Triangulation2D self, int I, CTriangle2D* T)
