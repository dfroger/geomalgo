from .point cimport Point

cdef class Segment:

    cdef public:
        Point A, B 
