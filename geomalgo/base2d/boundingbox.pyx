cdef class BoundingBox:
    def __init__(BoundingBox self,
                 double xmin=0., double xmax=0.,
                 double ymin=0., double ymax=0.):
        self.xmin = xmin
        self.xmax = xmax

        self.ymin = ymin
        self.ymax = ymax
