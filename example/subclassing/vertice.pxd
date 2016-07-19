from geomalgo cimport Point2D

cdef class Vertice(Point2D):
    cdef public:
        double alpha

    cdef double cmeth(self)

