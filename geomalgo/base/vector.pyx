from libc.stdlib cimport malloc, free

cdef CVector* new_vector():
    return <CVector*> malloc(sizeof(CVector))

cdef void del_vector(CVector* cvector):
    if cvector is not NULL:
        free(cvector)

cdef void cross_product(CVector *c, CVector *a, CVector *b):
    c.x = a.y*b.z - a.z*b.y
    c.y = a.z*b.x - a.x*b.z
    c.z = a.x*b.y - a.y*b.x

cdef void subtract_vector(CVector *c, CVector *b, CVector *a):
    c.x = b.x - a.x
    c.y = b.y - a.y
    c.z = b.z - a.z

cdef double dot_product(CVector *a, CVector *b):
    return a.x*b.x + a.y*b.y + a.z*b.z

cdef class Vector:

    property x:
        def __get__(self):
            return self.cvector.x
        def __set__(self, double x):
            self.cvector.x = x
        
    property y:
        def __get__(self):
            return self.cvector.y
        def __set__(self, double y):
            self.cvector.y = y
        
    property z:
        def __get__(self):
            return self.cvector.z
        def __set__(self, double z):
            self.cvector.z = z

    def __cinit__(self):
        self.cvector = new_vector()

    def __dealloc__(self):
        if self.cvector is not NULL:
            free(self.cvector)

    def __init__(self, x, y, z):
        self.cvector.x = x
        self.cvector.y = y
        self.cvector.z = z

    def dot(Vector self, Vector other):
        cdef:
            Vector result = Vector.__new__(Vector)
        return dot_product(self.cvector, other.cvector)

    def __mul__(Vector self, Vector other):
        cdef:
            Vector result = Vector.__new__(Vector)
        cross_product(result.cvector, self.cvector, other.cvector)
        return result

    def __sub__(Vector self, Vector other):
        cdef:
            Vector result = Vector.__new__(Vector)
        subtract_vector(result.cvector, self.cvector, other.cvector)
        return result

    def __str__(self):
        return "<Vector({},{},{})>".format(self.cvector.x, self.cvector.y,
                                        self.cvector.z)
