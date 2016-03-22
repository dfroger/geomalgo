from libc.stdlib cimport malloc, free

cdef CVector* new_vector():
    return <CVector*> malloc(sizeof(CVector))

cdef void del_vector(CVector* cvector):
    if cvector is not NULL:
        free(cvector)

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

    def __str__(self):
        return "<Vector({},{})>".format(self.cvector.x, self.cvector.y,
                                        self.cvector.z)
