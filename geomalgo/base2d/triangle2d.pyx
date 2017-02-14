import matplotlib.pyplot as plt

from libc.stdlib cimport malloc, free
from libc.math cimport fabs

from .point2d cimport CPoint2D, subtract_points2d
from .vector2d cimport CVector2D
from .segment2d cimport (
    CSegment2D, segment2d_square_distance_point2d, segment2d_set
)
from .polygon2d cimport CPolygon2D


# ============================================================================
# Structures
# ============================================================================


cdef CTriangle2D* new_triangle2d():
    return <CTriangle2D*> malloc(sizeof(CTriangle2D))


cdef void del_triangle2d(CTriangle2D* ctri2d):
    if ctri2d is not NULL:
        free(ctri2d)


# ============================================================================
# Computational functions
# ============================================================================


cdef bint triangle2d_includes_point2d(CTriangle2D* ABC, CPoint2D* P,
                                      double edge_width_square):

    # inclusion.winding.polygon2d_winding_point2d specialized for triangle,
    # just for optimisation.

    cdef:
        int winding_number = 0
        bint included

    # [AB]
    if ABC.A.y <= P.y:
        if ABC.B.y > P.y and is_left(ABC.A, ABC.B, P) > 0:
            winding_number +=  1
    elif ABC.B.y <= P.y and is_left(ABC.A, ABC.B, P) < 0:
        winding_number -=  1

    # [BC]
    if ABC.B.y <= P.y:
        if ABC.C.y > P.y and is_left(ABC.B, ABC.C, P) > 0:
            winding_number +=  1
    elif ABC.C.y <= P.y and is_left(ABC.B, ABC.C, P) < 0:
        winding_number -=  1

    # [CA]
    if ABC.C.y <= P.y:
        if ABC.A.y  > P.y and is_left(ABC.C, ABC.A, P) > 0:
            winding_number +=  1
    elif ABC.A.y <= P.y and is_left(ABC.C, ABC.A, P) < 0:
        winding_number -=  1

    included = winding_number != 0

    if not included and edge_width_square != 0:
        return triangle2d_on_edges(ABC, P, edge_width_square) != -1
    else:
        return included


cdef int triangle2d_on_edges(CTriangle2D* ABC, CPoint2D* P,
                             double edge_width_square):
    """
    Return which triangle edge point P is on (0, 1 or 2), or -1
    """
    cdef:
        CSegment2D seg
        CVector2D u

    segment2d_set(&seg, ABC.A, ABC.B)
    subtract_points2d(&u, ABC.B, ABC.A)
    if segment2d_square_distance_point2d(&seg, &u, P) <= edge_width_square:
        return 0

    segment2d_set(&seg, ABC.B, ABC.C)
    subtract_points2d(&u, ABC.C, ABC.B)
    if segment2d_square_distance_point2d(&seg, &u, P) <= edge_width_square:
        return 1

    segment2d_set(&seg, ABC.C, ABC.A)
    subtract_points2d(&u, ABC.A, ABC.C)
    if segment2d_square_distance_point2d(&seg, &u, P) <= edge_width_square:
        return 2

    return -1


cdef void triangle2d_gradx_grady_det(CTriangle2D* tri, double signed_area,
                                     double gradx[3], double grady[3],
                                     double det[3]):
    cdef:
        double xa = tri.A.x, ya = tri.A.y
        double xb = tri.B.x, yb = tri.B.y
        double xc = tri.C.x, yc = tri.C.y
        double alpha = 0.5 / signed_area

    gradx[0] = (yb - yc) * alpha
    gradx[1] = (yc - ya) * alpha
    gradx[2] = (ya - yb) * alpha

    grady[0] = (xc - xb) * alpha
    grady[1] = (xa - xc) * alpha
    grady[2] = (xb - xa) * alpha

    det[0] = (xb*yc - xc*yb) * alpha
    det[1] = (xc*ya - xa*yc) * alpha
    det[2] = (xa*yb - xb*ya) * alpha


# ============================================================================
# Python API
# ============================================================================


cdef class Triangle2D:

    property A:
        def __get__(self):
            return self.A
        def __set__(self, Point2D A):
            self.A = A
            # C points to Python.
            self.ctri2d.A = A.cpoint2d


    property B:
        def __get__(self):
            return self.B
        def __set__(self, Point2D B):
            self.B = B
            # C points to Python.
            self.ctri2d.B = B.cpoint2d


    property C:
        def __get__(self):
            return self.C
        def __set__(self, Point2D C):
            self.C = C
            # C points to Python.
            self.ctri2d.C = C.cpoint2d


    property area:
        def __get__(self):
            return fabs(self.signed_area)


    property center:
        def __get__(self):
            cdef:
                Point2D C = Point2D.__new__(Point2D)
            triangle2d_center(&self.ctri2d, C.cpoint2d)
            return C


    property counterclockwise:
        def __get__(self):
            return self.signed_area > 0.


    def __init__(self, Point2D A, Point2D B, Point2D C, index=0,
                 force_counterclockwise=False):
        self.A = A
        self.B = B
        self.C = C
        self.index = index

        # C points to Python.
        self.ctri2d.A = A.cpoint2d
        self.ctri2d.B = B.cpoint2d
        self.ctri2d.C = C.cpoint2d

        self.signed_area = triangle2d_signed_area(&self.ctri2d)
        if self.signed_area == 0.:
            raise ValueError("Triangle is degenerated")

        if force_counterclockwise and self.signed_area < 0.:
            # Swap points B and C.
            self.B = C
            self.C = B
            self.ctri2d.B = C.cpoint2d
            self.ctri2d.C = B.cpoint2d

        self.recompute()


    def recompute(Triangle2D self):
        """Must be called manually if any point coordinate changed"""
        self.signed_area = triangle2d_signed_area(&self.ctri2d)

        triangle2d_gradx_grady_det(&self.ctri2d, self.signed_area,
                                   self.gradx, self.grady, self.det)


    def includes_point(Triangle2D self, Point2D point,
                       double edge_width=0.):
        return triangle2d_includes_point2d(&self.ctri2d, point.cpoint2d,
                                           edge_width**2)


    def interpolate(Triangle2D self, double[:] data, Point2D P):
        cdef:
            double f0, f1, f2

        f0 = self.det[0] + P.x*self.gradx[0] + P.y*self.grady[0]
        f1 = self.det[1] + P.x*self.gradx[1] + P.y*self.grady[1]
        f2 = self.det[2] + P.x*self.gradx[2] + P.y*self.grady[2]

        return f0*data[0] + f1*data[1] + f2*data[2]


    cdef _set_precomputed(Triangle2D self, Point2D A, Point2D B, Point2D C,
                          int index, double signed_area, double gradx[3],
                          double grady[3], double det[3]):
        self.A = A
        self.B = B
        self.C = C
        self.index = index

        # C points to Python.
        self.ctri2d.A = A.cpoint2d
        self.ctri2d.B = B.cpoint2d
        self.ctri2d.C = C.cpoint2d

        self.signed_area = signed_area
        self.gradx = gradx
        self.grady = grady
        self.det = det

    cdef alloc_new(Triangle2D self):
        # TODO: Do it in __new__, and adapt __init__
        self.A = Point2D.__new__(Point2D)
        self.B = Point2D.__new__(Point2D)
        self.C = Point2D.__new__(Point2D)

        # C points to Python.
        self.ctri2d.A = self.A.cpoint2d
        self.ctri2d.B = self.B.cpoint2d
        self.ctri2d.C = self.C.cpoint2d

    def plot(self, color='blue', lw=2):
        x = [self.A.x, self.B.x, self.C.x, self.A.x]
        y = [self.A.y, self.B.y, self.C.y, self.A.y]
        plt.plot(x, y, color=color, lw=lw)
