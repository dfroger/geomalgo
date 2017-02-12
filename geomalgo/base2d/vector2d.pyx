from libc.stdlib cimport malloc, free


# ============================================================================
# Structures
# ============================================================================


cdef CVector2D* new_vector2d():
    return <CVector2D*> malloc(sizeof(CVector2D))

cdef void del_vector2d(CVector2D* V):
    if V is not NULL:
        free(V)


# ============================================================================
# Python API
# ============================================================================


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

    property normal:
        """
        Compute and return normal

        Normal BN of vector AB is such as ABN is clockwise

        A---------B
                  |
                  |
                  N
        """

        def __get__(self):
            cdef:
                Vector2D normal = Vector2D.__new__(Vector2D)
            compute_normal2d(normal.cvector2d, self.cvector2d, self.norm)
            return normal

    def __cinit__(self):
        self.cvector2d = new_vector2d()

    def __dealloc__(self):
        if self.cvector2d is not NULL:
            free(self.cvector2d)

    def __init__(self, x, y):
        self.cvector2d.x = x
        self.cvector2d.y = y

    def dot(Vector2D self, Vector2D other):
        """Compute dot product between two vectors"""
        cdef:
            Vector2D result = Vector2D.__new__(Vector2D)
        return dot_product2d(self.cvector2d, other.cvector2d)

    def normalize(self):
        normalize_vector2d(self.cvector2d)

    def __mul__(Vector2D self, double alpha):
        cdef:
            Vector2D result = Vector2D.__new__(Vector2D)
        vector2d_times_scalar(result.cvector2d, alpha, self.cvector2d)
        return result

    def __xor__(Vector2D self, Vector2D other):
        """Compute cross product between two vectors"""
        return cross_product2d(self.cvector2d, other.cvector2d)

    def __sub__(Vector2D self, Vector2D other):
        cdef:
            Vector2D result = Vector2D.__new__(Vector2D)
        subtract_vector2d(result.cvector2d, self.cvector2d, other.cvector2d)
        return result

    def __add__(Vector2D self, Vector2D other):
        cdef:
            Vector2D result = Vector2D.__new__(Vector2D)
        add_vector2d(result.cvector2d, self.cvector2d, other.cvector2d)
        return result

    def __str__(self):
        return "<Vector2D({},{}>".format(self.cvector2d.x,
                                             self.cvector2d.y)
