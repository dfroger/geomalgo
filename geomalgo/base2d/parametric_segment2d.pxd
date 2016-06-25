from .point2d cimport CPoint2D, point2d_plus_vector2d
from .vector2d cimport CVector2D
from ..base1d.parametric_coord1d cimport CParametricCoord1D

cdef struct CParametricSegment2D:
    CPoint2D* A
    CVector2D* AB

cdef CParametricSegment2D* new_parametric_segment2d()

cdef void del_parametric_segment2d(CParametricSegment2D* S)

cdef inline parametric_segment2d_at(CPoint2D* result, CParametricSegment2D S,
                                    CParametricCoord1D coord):
    """
    A     P
    +-----+-----> AB

    P = A + coord*AB

    Note
    ----
    
    This can be derived from 1D interpolation formuale:

        a   x       b
        +---+-------+

        alpha = (x-a) / (b-a)

        fx = (1-alpha)*fa + alpha*fb
           = fa + alpha*(fb-fa)

    So:
        px = xa + alpha*(xb-xa)
        py = ya + alpha*(yb-ya)

    However, we keep simple and use 'point2d_plus_vector2d' function instead
    of generic inteporlation functions.
    """
    point2d_plus_vector2d(result, S.A, coord, S.AB)
