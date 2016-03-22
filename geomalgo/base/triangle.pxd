from .point cimport CPoint, Point

cdef struct CTriangle:
    CPoint* A
    CPoint* B
    CPoint* C
    
cdef CTriangle* new_triangle()

cdef void del_triangle(CTriangle* ctriangle)

cdef class Triangle:

    cdef public:
        Point A
        Point B
        Point C
