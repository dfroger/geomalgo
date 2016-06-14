from libc.stdlib cimport malloc, free
from libc.math cimport sqrt

cdef CVector3D* new_vector3d():
    return <CVector3D*> malloc(sizeof(CVector3D))

cdef void del_vector(CVector3D* V):
    if V is not NULL:
        free(V)

cdef void cross_product3d(CVector3D *c, CVector3D *a, CVector3D *b):
    c.x = a.y*b.z - a.z*b.y
    c.y = a.z*b.x - a.x*b.z
    c.z = a.x*b.y - a.y*b.x

cdef void subtract_vector3d(CVector3D *c, CVector3D *b, CVector3D *a):
    c.x = b.x - a.x
    c.y = b.y - a.y
    c.z = b.z - a.z

cdef double dot_product3d(CVector3D *a, CVector3D *b):
    return a.x*b.x + a.y*b.y + a.z*b.z

cdef double compute_norm3d(CVector3D *a):
    return sqrt( a.x*a.x \
               + a.y*a.y \
               + a.z*a.z )

cdef class Vector3D:

    property x:
        def __get__(self):
            return self.cvector3d.x
        def __set__(self, double x):
            self.cvector3d.x = x
        
    property y:
        def __get__(self):
            return self.cvector3d.y
        def __set__(self, double y):
            self.cvector3d.y = y
        
    property z:
        def __get__(self):
            return self.cvector3d.z
        def __set__(self, double z):
            self.cvector3d.z = z
            
    property norm:
        """Compute (involving sqrt) and return norm of the vector"""
        def __get__(self):
            return compute_norm3d(self.cvector3d)

    def __cinit__(self):
        self.cvector3d = new_vector3d()

    def __dealloc__(self):
        if self.cvector3d is not NULL:
            free(self.cvector3d)

    def __init__(self, x, y, z):
        self.cvector3d.x = x
        self.cvector3d.y = y
        self.cvector3d.z = z

    def dot(Vector3D self, Vector3D other):
        """Compute dot prodcution between two vectors"""
        cdef:
            Vector3D result = Vector3D.__new__(Vector3D)
        return dot_product3d(self.cvector3d, other.cvector3d)

    def __mul__(Vector3D self, Vector3D other):
        """Compute cross prodcution between two vectors"""
        cdef:
            Vector3D result = Vector3D.__new__(Vector3D)
        cross_product3d(result.cvector3d, self.cvector3d, other.cvector3d)
        return result

    def __sub__(Vector3D self, Vector3D other):
        """Subtract two vectors"""
        cdef:
            Vector3D result = Vector3D.__new__(Vector3D)
        subtract_vector3d(result.cvector3d, self.cvector3d, other.cvector3d)
        return result

    def __str__(self):
        return "<Vector3D({},{},{})>".format(self.cvector3d.x,
                                             self.cvector3d.y,
                                             self.cvector3d.z)
