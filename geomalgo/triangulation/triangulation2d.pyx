from libc.stdlib cimport malloc, free

cdef CTriangulation2D* new_ctriangulation2d():
    return <CTriangulation2D*> malloc(sizeof(CTriangulation2D))

cdef void del_ctriangulation2d(CTriangulation2D* ctriangulation2d):
    if ctriangulation2d is not NULL:
        free(ctriangulation2d)

cdef class Triangulation2D:

    def __init__(self, double[:] x, double[:] y, int[:,:] trivtx):
        self.x = x
        self.y = y
        self.trivtx = trivtx
