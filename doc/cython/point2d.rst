*******
Point2D
*******

The Cython API for points in two-dimensional points provide a simple CPoint2D
strucutre and some computational functions.

Structures
==========

.. c:type:: CPoint2D

    .. c:member:: double x

    .. c:member:: double y

		Represents a point two-dimensional space, of coordinates :math:`(x, y)`.


.. c:function:: CPoint2D* new_point2d()

   Allocate a new CPoint2D


.. c:function:: del_point2d(CPoint2D* cpoint2d)

   Delete a CPoint2D


.. c:function:: bint point2d_equal(CPoint2D* A, CPoint2D* B)

   Test whether two points :math:`A` and :math:`B` are strictly equal.


.. literalinclude:: examples/cpoint2d.pyx


Computational functions
=======================


.. c:function:: void subtract_points2d(CVector2D* AB, const CPoint2D* B, const CPoint2D* A)

    Compute the vector :math:`\mathbf{AB} = B - A`.

    Variable ``AB`` must be already allocated.


.. c:function:: void point2d_plus_vector2d(CPoint2D* B, CPoint2D* A, double alpha, CVector2D* AB)

    Compute the point :math:`B = A + \alpha \mathbf{AB}`.

    ``B`` must be already allocated.


.. c:function:: double point2d_distance(CPoint2D* A, CPoint2D* B)

    Compute the distance between points :math:`A` and :math:`B`.


.. c:function:: double point2d_square_distance(CPoint2D* A, CPoint2D* B)

    Compute the square of distance between to points :math:`A` and :math:`B`.

    Sometime, the knowledge of the square distance is enough, and for
    performance, computing the square root can be avoided.


.. c:function:: double is_left(CPoint2D* A, CPoint2D* B, CPoint2D* P)

    Test if the point :math:`P` is left, right, or of an infinite
    line :math:`(AB)`.

    The value returned is:
      - Strictly **negative** if :math:`P` is right of the line through :math:`A`
        to :math:`B`.
      - Strictly **positive** if :math:`P` is left of the line through A to B.
      - **Zero** if :math:`P` is on the line :math:`(AB)`.


Python and Cython API relation
==============================
