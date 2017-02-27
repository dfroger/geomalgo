from .point3d cimport CPoint3D, Point3D, CVector3D, Vector3D


# ============================================================================
# Structures
# ============================================================================


cdef struct CPlane:
    CPoint3D* point
    CVector3D* normal

cdef CPlane* new_plane()

cdef void del_plane(CPlane* plane)


# ============================================================================
# Computational functions
# ============================================================================


cdef void point_projection_to_plane(CPoint3D* point, CPlane* plane,
                                    CPoint3D* projection)


# ============================================================================
# Python API
# ============================================================================


cdef class Plane:

    cdef public:
        Point3D point
        Vector3D normal
