from libc.math cimport sin, cos

cdef class PolarPoint:
    cdef:
        double r
        double theta
