from libc.stdlib cimport malloc, free
from libc.math cimport fabs

from .polygon2d cimport CPolygon2D
from ..inclusion cimport polygon2d_winding_point2d

cdef CTriangle2D* new_triangle2d():
    return <CTriangle2D*> malloc(sizeof(CTriangle2D))

cdef void del_triangle2d(CTriangle2D* ctri2d):
    if ctri2d is not NULL:
        free(ctri2d)

cdef void triangle2d_from_triangulation2d(CTriangle2D* T,
                                          CTriangulation2D* TG,
                                          int triangle_index):
    """
    Set 2D triangle point coordinates from its index in a triangulation

    Notes:
    ------

    Triangle points must be allocated before calling this function.
    """
    cdef:
        int ia, ib, ic

    # Get points A, B and C indexes.
    ia = TG.trivtx[triangle_index,0]
    ib = TG.trivtx[triangle_index,1]
    ic = TG.trivtx[triangle_index,2]

    # Set triangle point A coordinates
    T.A.x = TG.x[ia]
    T.A.y = TG.y[ia]

    # Set triangle point B coordinates
    T.B.x = TG.x[ib]
    T.B.y = TG.y[ib]

    # Set triangle point C coordinates
    T.C.x = TG.x[ic]
    T.C.y = TG.y[ic]

cdef bint triangle2d_includes_point2d(CTriangle2D* ctri2d, CPoint2D* P):
    """
    inclusion.winding.polygon2d_winding_point2d specialized for triangle,
    just for optimisation.
    """
    cdef:
        int winding_number = 0

    # [AB]
    if ctri2d.A.y <= P.y:
        if ctri2d.B.y > P.y and c_is_left(ctri2d.A, ctri2d.B, P) > 0:
            winding_number +=  1
    elif ctri2d.B.y <= P.y and c_is_left(ctri2d.A, ctri2d.B, P) < 0:
        winding_number -=  1

    # [BC]
    if ctri2d.B.y <= P.y:
        if ctri2d.C.y > P.y and c_is_left(ctri2d.B, ctri2d.C, P) > 0:
            winding_number +=  1
    elif ctri2d.C.y <= P.y and c_is_left(ctri2d.B, ctri2d.C, P) < 0:
        winding_number -=  1

    # [CA]
    if ctri2d.C.y <= P.y:
        if ctri2d.A.y  > P.y and c_is_left(ctri2d.C, ctri2d.A, P) > 0:
            winding_number +=  1
    elif ctri2d.A.y <= P.y and c_is_left(ctri2d.C, ctri2d.A, P) < 0:
        winding_number -=  1

    return winding_number != 0

cdef void triangle2d_gradx_grady_det(CTriangle2D* tri, double area,
                                     double gradx[3], double grady[3],
                                     double det[3]):
    cdef:
        double xa = tri.A.x, ya = tri.A.y
        double xb = tri.B.x, yb = tri.B.y
        double xc = tri.C.x, yc = tri.C.y
        double alpha = 0.5 / area

    gradx[0] = (yb - yc) * alpha
    gradx[1] = (yc - ya) * alpha
    gradx[2] = (ya - yb) * alpha

    grady[0] = (xc - xb) * alpha
    grady[1] = (xa - xc) * alpha
    grady[2] = (xb - xa) * alpha

    det[0] = (xb*yc - xc*yb) * alpha
    det[1] = (xc*ya - xa*yc) * alpha
    det[2] = (xa*yb - xb*ya) * alpha

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

        triangle2d_gradx_grady_det(&self.ctri2d, self.area,
                                   self.gradx, self.grady, self.det)

    def includes_point(Triangle2D self, Point2D point):
        return triangle2d_includes_point2d(&self.ctri2d, point.cpoint2d)

    def interpolate(Triangle2D self, double[:] data, Point2D P):
        cdef:
            double f0, f1, f2

        f0 = self.det[0] + P.x*self.gradx[0] + P.y*self.grady[0]
        f1 = self.det[1] + P.x*self.gradx[1] + P.y*self.grady[1]
        f2 = self.det[2] + P.x*self.gradx[2] + P.y*self.grady[2]

        return f0*data[0] + f1*data[1] + f2*data[2]
