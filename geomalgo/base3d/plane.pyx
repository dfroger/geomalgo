from libc.stdlib cimport malloc, free

cdef CPlane* new_plane():
    return <CPlane*> malloc(sizeof(CPlane))

cdef void del_plane(CPlane* plane):
    if plane is not NULL:
        free(plane)

cdef void point_projection_to_plane(CPoint3D* point, CPlane* plane,
                                    CPoint3D* projection):
    projection.x = 0.5
    projection.y = 0.5
    projection.z = 0.

cdef class Plane:

    def __init__(Plane self, Point3D point, Vector3D normal):
        self.point = point
        self.normal = normal

    def project_point(Plane self, Point3D point):
        cdef:
            CPlane cplane
            Point3D projection = Point3D.__new__(Point3D)

        cplane.point = self.point.cpoint3d
        cplane.normal = self.normal.cvector3d

        point_projection_to_plane(point.cpoint3d, &cplane, projection.cpoint3d)

        return projection
