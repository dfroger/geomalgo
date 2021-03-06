from .point3d cimport CPoint3D, Point3D


# ============================================================================
# Structures
# ============================================================================


cdef struct CTriangle3D:
    CPoint3D* A
    CPoint3D* B
    CPoint3D* C


cdef CTriangle3D* new_triangle3d()


cdef void del_triangle3d(CTriangle3D* T)


# ============================================================================
# Computational functions
# ============================================================================


cdef double triangle3d_area(CTriangle3D* T)


cdef inline void triangle3d_center(CTriangle3D* T, CPoint3D* C):
    C.x = (T.A.x + T.B.x + T.C.x) / 3.
    C.y = (T.A.y + T.B.y + T.C.y) / 3.
    C.z = (T.A.z + T.B.z + T.C.z) / 3.


cdef void compute_symetric_point3d(CPoint3D* S, CTriangle3D* T, CPoint3D* P)


# ============================================================================
# Python API
# ============================================================================


cdef class Triangle3D:

    cdef public:
        int index

    cdef:
        Point3D A
        Point3D B
        Point3D C
        CTriangle3D ctri3d
