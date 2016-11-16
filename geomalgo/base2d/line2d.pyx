from libc.stdlib cimport malloc, free

cdef CLine2D* new_line2d():
    return <CLine2D*> malloc(sizeof(CLine2D))

cdef void del_line2d(CLine2D* cline2d):
    if cline2d is not NULL:
        free(cline2d)

cdef CLine2D* create_line2d(CPoint2D* A, CPoint2D* B):
    cdef:
        CLine2D* line = new_line2d()
    line.A = A
    line.B = B
    return line

cdef class Line2D:

    property A:
        def __get__(self):
            return self.A
        def __set__(self, Point2D A):
            self.A = A
            # C points to Python.
            self.cline2d.A = A.cpoint2d

    property B:
        def __get__(self):
            return self.B
        def __set__(self, Point2D B):
            self.B = B
            # C points to Python.
            self.cline2d.B = B.cpoint2d

    def __init__(self, Point2D A, Point2D B):
        self.A = A
        self.B = B

        # C points to Python.
        self.cline2d.A = A.cpoint2d
        self.cline2d.B = B.cpoint2d

    def __str__(self):
        return "Line2D(({self.A.x},{self.A.y}),({self.B.x},{self.B.y}))" \
               .format(self=self)
