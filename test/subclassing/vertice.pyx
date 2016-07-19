from geomalgo cimport Point2D

cdef class Vertice(Point2D):
    cdef public:
        double alpha

    def __init__(self, x, y, alpha):
        Point2D.__init__(self, x, y)
        self.alpha = alpha

    def meth(self):
        return self.alpha

    cdef double cmeth(self):
        return self.alpha

