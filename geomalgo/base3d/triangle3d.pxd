from .point3d cimport CPoint3D, Point3D

cdef struct CTriangle3D:
    CPoint3D* A
    CPoint3D* B
    CPoint3D* C
    
cdef CTriangle3D* new_triangle3d()

cdef void del_triangle3d(CTriangle3D* T)

cdef double compute_area3d(CTriangle3D* T)

cdef void compute_symetric_point3d(CPoint3D* S, CTriangle3D* T, CPoint3D* P)

cdef class Triangle3D:

    cdef public:
        Point3D A
        Point3D B
        Point3D C
