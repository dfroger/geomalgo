from libc.stdlib cimport malloc, free

cdef CTriangulation2D* new_ctriangulation2d():
    return <CTriangulation2D*> malloc(sizeof(CTriangulation2D))

cdef void del_ctriangulation2d(CTriangulation2D* ctriangulation2d):
    if ctriangulation2d is not NULL:
        free(ctriangulation2d)

