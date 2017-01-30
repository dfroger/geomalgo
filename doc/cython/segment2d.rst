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

    .. c:member:: CVector2D* AB

        :math:`AB` is the vector from :math:`A` to :math:`B`.


.. c:function:: CSegment2D* new_segment2d()

    Allocate a new CSegment2D.

    This do **not** allocate members ``A``, ``B``, and ``AB``.


.. c:function:: void del_segment2d(CSegment2D* csegment2d)

    Delete a CSegment2D.

    This do **not** delete members ``A``, ``B``, and ``AB``.


.. c:function:: void segment2d_set(CSegment2D* AB, CPoint2D* A, CPoint2D* B)

    Set members ``A`` and ``B``, and compute member ``AB``.


.. c:function:: CSegment2D* create_segment2d(CPoint2D* A, CPoint2D* B)

    Allocate a new CSegment2D.

    Set members ``A`` and ``B``, and compute member ``AB``.


Computational functions
=======================


.. c:function:: double segment2d_distance_point2d(CSegment2D* AB, CPoint2D* P)

    Compute distance of a point :math:`P` to the segment :math:`[AB]`.


.. c:function:: double segment2d_square_distance_point2d(CSegment2D* AB, CPoint2D* P)

    Compute distance of a point :math:`P` to the segment :math:`[AB]`.

    Sometime, the knowledge of the square distance is enough, and for
    performance, computing the square root can be avoided.


.. c:function:: void segment2d_at(CPoint2D* P, CSegment2D* AB, double alpha)

    Compute point :math:`P` such as :math:`P = A + \alpha \mathbf{AB}`.

    Variable ``P`` must be already allocated.


.. c:function:: double segment2d_where(CSegment2D* AB, CPoint2D* P)

    Compute :math:`\alpha` such as :math:`P = A + \alpha \mathbf{AB}`.

    This assumes point :math:`P` in on line :math:`(AB)`.


.. c:function:: void segment2d_middle(CPoint2D* M, CSegment2D* AB)

    Compute the point :math:`M`, middle of the segment :math:`[AB]`.
