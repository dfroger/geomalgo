*********
Segment2D
*********


Structures
==========


.. c:type:: CSegment2D

    .. c:member:: CPoint2D* A

        :math:`A` is the first segment point.

    .. c:member:: CPoint2D* B

        :math:`B` is the second segment point.


.. note::

    :c:type:`CSegment2D` represents a segment by two points. A segment may
    also be represented by a point and a vector. There is no C structure
    that represent a segment this way. If needed by a function, a
    :c:type:`Point2D` and a :c:type:`Vector2D` must be passed explicitly.
    See for example :c:type:`segment2d_where`.


.. c:function:: CSegment2D* new_segment2d()

    Allocate a new CSegment2D.

    This do **not** allocate members ``A``, ``B``.


.. c:function:: void del_segment2d(CSegment2D* csegment2d)

    Delete a CSegment2D.

    This do **not** delete members ``A``, ``B``.


.. c:function:: void segment2d_set(CSegment2D* AB, CPoint2D* A, CPoint2D* B)

    Set members ``A`` and ``B``.



Computational functions
=======================


.. c:function:: double segment2d_distance_point2d(CSegment2D* AB, CVector2D* u, CPoint2D* P)

    Compute distance of a point :math:`P` to the segment :math:`[AB]`.

    :math:`\mathbf{u}` is the vector from :math:`A` to :math:`A`.


.. c:function:: double segment2d_square_distance_point2d(CSegment2D* AB, CVector2D* u, CPoint2D* P)

    Compute distance of a point :math:`P` to the segment :math:`[AB]`.

    :math:`\mathbf{u}` is the vector from :math:`A` to :math:`A`.

    Sometime, the knowledge of the square distance is enough, and for
    performance, computing the square root can be avoided.


.. c:function:: double segment2d_where(CPoint2D* A, CVector2D* AB, CPoint2D* P)

    Compute :math:`\alpha` such as :math:`P = A + \alpha \mathbf{AB}`.

    This assumes point :math:`P` in on line :math:`(AB)`.


.. c:function:: void segment2d_middle(CPoint2D* M, CSegment2D* AB)

    Compute the point :math:`M`, middle of the segment :math:`[AB]`.
