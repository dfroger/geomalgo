from libc.stdlib cimport malloc, free

from .point cimport new_point, del_point

cdef CTriangle* new_triangle():
    return <CTriangle*> malloc(sizeof(CTriangle))

cdef void del_triangle(CTriangle* ctriangle):
    if ctriangle is not NULL:
        free(ctriangle)

cdef class Triangle:

    def __init__(self, Point A, Point B, Point C):
        self.A = A
        self.B = B
        self.C = C
