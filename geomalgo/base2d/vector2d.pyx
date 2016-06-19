from libc.stdlib cimport malloc, free
from libc.math cimport sqrt

cdef CVector2D* new_vector2d():
    return <CVector2D*> malloc(sizeof(CVector2D))

cdef void del_vector(CVector2D* V):
    if V is not NULL:
        free(V)

cdef void subtract_vector2d(CVector2D *c, CVector2D *b, CVector2D *a):
    c.x = b.x - a.x
    c.y = b.y - a.y

cdef double dot_product2d(CVector2D *a, CVector2D *b):
    return a.x*b.x + a.y*b.y

cdef double compute_norm2d(CVector2D *a):
    return sqrt(a.x*a.x + a.y*a.y)

cdef class Vector2D:

    property x:
        def __get__(self):
            return self.cvector2d.x
        def __set__(self, double x):
            self.cvector2d.x = x
        
    property y:
        def __get__(self):
            return self.cvector2d.y
        def __set__(self, double y):
            self.cvector2d.y = y
            
    property norm:
        """Compute (involving sqrt) and return norm of the vector"""
        def __get__(self):
            return compute_norm2d(self.cvector2d)

    def __cinit__(self):
        self.cvector2d = new_vector2d()

    def __dealloc__(self):
        if self.cvector2d is not NULL:
            free(self.cvector2d)

    def __init__(self, x, y):
        self.cvector2d.x = x
        self.cvector2d.y = y

    def dot(Vector2D self, Vector2D other):
        """Compute dot prodcution between two vectors"""
        cdef:
            Vector2D result = Vector2D.__new__(Vector2D)
        return dot_product2d(self.cvector2d, other.cvector2d)

    def __sub__(Vector2D self, Vector2D other):
        """Subtract two vectors"""
        cdef:
            Vector2D result = Vector2D.__new__(Vector2D)
        subtract_vector2d(result.cvector2d, self.cvector2d, other.cvector2d)
        return result

    def __str__(self):
        return "<Vector2D({},{}>".format(self.cvector2d.x,
                                             self.cvector2d.y)

