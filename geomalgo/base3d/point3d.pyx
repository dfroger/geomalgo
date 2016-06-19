from libc.stdlib cimport malloc, free

cdef CPoint3D* new_point3d():
    return <CPoint3D*> malloc(sizeof(CPoint3D))

cdef void del_point3d(CPoint3D* cpoint3d):
    if cpoint3d is not NULL:
        free(cpoint3d)

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
            return self.cpoint3d.x
        def __set__(self, double x):
            self.cpoint3d.x = x
        
    property y:
        def __get__(self):
            return self.cpoint3d.y
        def __set__(self, double y):
            self.cpoint3d.y = y
        
    property z:
        def __get__(self):
            return self.cpoint3d.z
        def __set__(self, double z):
            self.cpoint3d.z = z

    def __cinit__(self):
        self.cpoint3d = new_point3d()

    def __dealloc__(self):
        del_point3d(self.cpoint3d)

    def __init__(self, x, y, z, index=0):
        self.cpoint3d.x = x
        self.cpoint3d.y = y
        self.cpoint3d.z = z
        self.index = index

    def __sub__(Point3D self, Point3D other):
        cdef:
            Vector3D vector = Vector3D.__new__(Vector3D)
        subtract_points3d(vector.cvector3d, self.cpoint3d, other.cpoint3d)
        return vector

    def distance(Point3D self, Point3D other):
        return c_point3d_distance(self.cpoint3d, other.cpoint3d)
