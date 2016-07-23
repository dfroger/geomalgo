cdef struct CTriangulation2D:
    double[:] x
    double[:] y
    int[:,:] trivtx

cdef CTriangulation2D* new_ctriangulation2d()

cdef void del_ctriangulation2d(CTriangulation2D* ctriangulation2d)

cdef class Triangulation2D:

    cdef public:
        double[:] x
        double[:] y
        int[:,:] trivtx
