cdef struct CPolygon2D:
    double* x
    double* y
    size_t points_number
   
cdef CPolygon2D* new_polygon2d()

cdef void del_polygon2d(CPolygon2D* cpolygon2d)

cdef class Polygon2D:
    """
    2-dimension list of N points P, with P[0] == P[N-1]
    """
    cdef public:
        double[:] _x
        double[:] _y
    cdef:
        CPolygon2D* cpolygon2d

