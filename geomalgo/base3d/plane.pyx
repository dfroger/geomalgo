from libc.stdlib cimport malloc, free

from .vector3d cimport dot_product3d
from .point3d cimport point3d_plus_vector3d, subtract_points3d


# ============================================================================
# Structures
# ============================================================================


cdef CPlane* new_plane():
    return <CPlane*> malloc(sizeof(CPlane))


cdef void del_plane(CPlane* plane):
    if plane is not NULL:
        free(plane)


# ============================================================================
# Computational functions
# ============================================================================


cdef void point_projection_to_plane(CPoint3D* P, CPlane* plane,
                                    CPoint3D* projection):
    """
    From http://geomalgorithms.com/a04-_planes.html
    """
    cdef:
        double sb, sn, sd
        CVector3D u

    subtract_points3d(&u, P, plane.point)

    sn = - dot_product3d(plane.normal, &u)
    sd =   dot_product3d(plane.normal, plane.normal)
    sb = sn / sd

    point3d_plus_vector3d(projection, P, sb, plane.normal)


# ============================================================================
# Python API
# ============================================================================


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
