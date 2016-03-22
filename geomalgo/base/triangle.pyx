cdef class Triangle:

    def __cinit__(self, Point A, Point B, Point C):
        self.A = A
        self.B = B
        self.C = C

