from libc.math cimport sin, cos

cdef class PolarPoint:
    cdef public:
        double r
        double theta
