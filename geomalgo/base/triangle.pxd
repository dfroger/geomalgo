from .point cimport Point

cdef class Triangle:

    cdef public:
        Point A, B, C
