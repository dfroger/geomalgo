cdef class Vector:

    def __cinit__(self, double x, double y, double z):
        self.x = x
        self.y = y
        self.z = z

    cdef void from_points(self, Point B, Point A):
        self.x = B.x - A.x
        self.y = B.y - A.y
        self.z = B.z - A.z
