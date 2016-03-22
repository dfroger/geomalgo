from libc.stdlib cimport malloc, free

cdef CPoint* new_point():
    return <CPoint*> malloc(sizeof(CPoint))

cdef void del_point(CPoint* cpoint):
    if cpoint is not NULL:
        free(cpoint)

cdef void subtract_points(CVector * u, const CPoint * B, const CPoint * A):
    u.x = B.x - A.x
    u.y = B.y - A.y
    u.z = B.z - A.z

cdef void point_plus_vector(CPoint* result, CPoint* start, double factor,
                            CVector* vector):
    result.x = start.x + factor*vector.x
    result.y = start.y + factor*vector.y
    result.z = start.z + factor*vector.z

cdef class Point:

    property x:
        def __get__(self):
            return self.cpoint.x
        def __set__(self, double x):
            self.cpoint.x = x
        
    property y:
        def __get__(self):
            return self.cpoint.y
        def __set__(self, double y):
            self.cpoint.y = y
        
    property z:
        def __get__(self):
            return self.cpoint.z
        def __set__(self, double z):
            self.cpoint.z = z

    def __cinit__(self):
        self.cpoint = new_point()

    def __dealloc__(self):
        del_point(self.cpoint)

    def __init__(self, x, y, z):
        self.cpoint.x = x
        self.cpoint.y = y
        self.cpoint.z = z

    def __sub__(Point self, Point other):
        cdef:
            Vector vector = Vector.__new__(Vector)
        subtract_points(vector.cvector, self.cpoint, other.cpoint)
        return vector
