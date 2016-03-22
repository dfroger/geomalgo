from .vector cimport Vector

cdef class Point:
    
    def __cinit__(self, double x, double y, double z):
        self.x = x
        self.y = y
        self.z = z

    def __sub__(self, other):
        return Vector(self.x - other.x,
                      self.y - other.y,
                      self.z - other.z)
