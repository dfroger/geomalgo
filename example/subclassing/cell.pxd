from geomalgo cimport Triangle2D

cdef class Cell(Triangle2D):
    cdef public:
        double alpha

    cdef double cmeth(self)

