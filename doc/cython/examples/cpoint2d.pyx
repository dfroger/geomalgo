from libc.stdio cimport printf

cimport geomalgo as ga

cdef:
    CPoint2d P

P.x = 1
P.y = 2

printf("%f %f", P.x, P.y)
