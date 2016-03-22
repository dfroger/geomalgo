from .point cimport Point

cdef class Vector:

    cdef public:
        double x, y, z

    cdef void from_points(self, Point A, Point B)
