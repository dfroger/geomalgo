cdef class Vertice(Point2D):
    def __init__(self, x, y, alpha):
        Point2D.__init__(self, x, y)
        self.alpha = alpha

    def meth(self):
        return self.alpha

    cdef double cmeth(self):
        return self.alpha
