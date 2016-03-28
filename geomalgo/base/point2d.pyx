from libc.stdlib cimport malloc, free

cdef CPoint2D* new_point2d():
    return <CPoint2D*> malloc(sizeof(CPoint2D))

cdef void del_point2d(CPoint2D* cpoint2d):
    if cpoint2d is not NULL:
        free(cpoint2d)

cdef class Point2D:

    property x:
        def __get__(self):
            return self.cpoint2d.x
        def __set__(self, double x):
            self.cpoint2d.x = x
        
    property y:
        def __get__(self):
            return self.cpoint2d.y
        def __set__(self, double y):
            self.cpoint2d.y = y

    def __cinit__(self):
        self.cpoint2d = new_point2d()

    def __dealloc__(self):
        del_point2d(self.cpoint2d)

    def __init__(self, x, y):
        self.cpoint2d.x = x
        self.cpoint2d.y = y
