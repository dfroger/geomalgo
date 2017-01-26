from libc.math cimport sqrt


# ============================================================================
# Structures
# ============================================================================


cdef struct CVector2D:
    double x
    double y

cdef CVector2D* new_vector2d()

cdef void del_vector2d(CVector2D* V)


# ===========================================================================
# Computational functions
# ============================================================================


cdef inline void vector2d_times_scalar(CVector2D *t, double alpha, CVector2D *u):
    t.x = alpha * u.x
    t.y = alpha * u.y


cdef inline void subtract_vector2d(CVector2D *AB, CVector2D *AC, CVector2D *BC):
    AB.x = AC.x - BC.x
    AB.y = AC.y - BC.y


cdef inline void add_vector2d(CVector2D *AC, CVector2D *AB, CVector2D *BC):
    AC.x = AB.x + BC.x
    AC.y = AB.y + BC.y


cdef inline double cross_product2d(CVector2D *u, CVector2D *v):
    return u.x*v.y - u.y*v.x


cdef inline double dot_product2d(CVector2D *u, CVector2D *v):
    return u.x*v.x + u.y*v.y


cdef inline double compute_norm2d(CVector2D *u):
    return sqrt(u.x*u.x + u.y*u.y)


cdef inline void normalize_vector2d(CVector2D *u):
    cdef:
        double norm = compute_norm2d(u)
    u.x /= norm
    u.y /= norm


cdef inline void compute_normal2d(CVector2D *n, CVector2D *u, double norm):
    n.x =  u.y / norm
    n.y = -u.x / norm


# ============================================================================
# Python API
# ============================================================================


cdef class Vector2D:
    cdef:
        CVector2D* cvector2d

