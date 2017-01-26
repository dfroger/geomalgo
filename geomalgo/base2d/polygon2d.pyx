from libc.stdlib cimport malloc, free

from .point2d cimport Point2D
from ..inclusion cimport polygon2d_winding_point2d

import numpy as np


# ============================================================================
# Structures
# ============================================================================


cdef CPolygon2D* new_polygon2d():
    return <CPolygon2D*> malloc(sizeof(CPolygon2D))


cdef void del_polygon2d(CPolygon2D* cpolygon2d):
    if cpolygon2d is not NULL:
        free(cpolygon2d)


# ============================================================================
# Python API
# ============================================================================


cdef class Polygon2D:

    property x:
        def __get__(self):
            return np.asarray(self._x)

    property y:
        def __get__(self):
            return np.asarray(self._y)

    def __cinit__(self):
        self.cpolygon2d = new_polygon2d()

    def __dealloc__(self):
        del_polygon2d(self.cpolygon2d)

    def __init__(self, x, y):
        self._x = np.asarray(x, dtype='d')
        self._y = np.asarray(y, dtype='d')

        # Initialize C structure
        self.cpolygon2d.points_number = self._x.shape[0]
        self.cpolygon2d.x = &self._x[0]
        self.cpolygon2d.y = &self._y[0]

    def includes_point(self, Point2D P):
        winding_number = polygon2d_winding_point2d(self.cpolygon2d,
                                                   P.cpoint2d)
        return winding_number != 0

    @staticmethod
    def from_points2d(points2d):
        x = [P.x for P in points2d]
        y = [P.y for P in points2d]
        return Polygon2D(x, y)
