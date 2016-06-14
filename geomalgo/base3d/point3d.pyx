from libc.stdlib cimport malloc, free

cdef CPoint3D* new_point3d():
    return <CPoint3D*> malloc(sizeof(CPoint3D))

cdef void del_point3d(CPoint3D* cpoint):
    if cpoint is not NULL:
        free(cpoint)

cdef void subtract_points3d(CVector3D * u, const CPoint3D * B,
                            const CPoint3D * A):
    u.x = B.x - A.x
    u.y = B.y - A.y
    u.z = B.z - A.z

cdef void point3d_plus_vector3d(CPoint3D* result, CPoint3D* start,
                                double factor, CVector3D* vector):
    result.x = start.x + factor*vector.x
    result.y = start.y + factor*vector.y
    result.z = start.z + factor*vector.z

cdef class Point3D:

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
        self.cpoint = new_point3d()

    def __dealloc__(self):
        del_point3d(self.cpoint)

    def __init__(self, x, y, z):
        self.cpoint.x = x
        self.cpoint.y = y
        self.cpoint.z = z

    def __sub__(Point3D self, Point3D other):
        cdef:
            Vector3D vector = Vector3D.__new__(Vector3D)
        subtract_points3d(vector.cvector3d, self.cpoint, other.cpoint)
        return vector
