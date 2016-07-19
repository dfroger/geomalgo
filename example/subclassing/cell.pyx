from geomalgo cimport Point2D

cdef class Cell(Triangle2D):

    def __init__(self, Point2D A, Point2D B, Point2D C, alpha):
        Triangle2D.__init__(self, A, B, C)
        self.alpha = alpha

    def meth(self):
        return self.alpha

    cdef double cmeth(self):
        return self.alpha
