**********
Triangle2d
**********


Structures
==========


.. c:type:: CTriangle2D

    .. c:member:: CPoint2D* A

        :math:`A` is the first triangle vertice.

    .. c:member:: CPoint2D* B

        :math:`B` is the second triangle vertice.

    .. c:member:: CPoint2D* C

        :math:`C` is the third triangle vertice.


.. c:function:: CTriangle2D* new_triangle2d()

    Allocate a new CTriangle2D.

    This do **not** allocate members ``A``, ``B``, and ``C``.


.. c:function:: void del_triangle2d(CTriangle2D* ctri2d)

    Delete a CTriangle2D.

    This do **not** delete members ``A``, ``B``, and ``C``.


.. c:function:: void triangle2d_set(CTriangle2D* ABC, CPoint2D* A, CPoint2D* B, CPoint2D* C)

    Set triangle points :math:`A`, :math:`B`, :math:`C`.


Computational functions
=======================

.. c:function:: bint triangle2d_includes_point2d(CTriangle2D* ABC, CPoint2D* P, double edge_width_square)

    Test if the triangle :math:`ABC` includes (contains) the point :math:`P`.

    If point :math:`P` is on one of the edge of triangle :math:`ABC`, due to
    `numerical accuracy issues <https://totologic.blogspot.fr/2014/01/accurate-point-in-triangle-test.html>`_,
    the test may failed.

    To solve this issue, if ``edge_width_square`` is not ``0``, `ABC` will be
    considered to include :math:`P` if distance between :math:`P` and one of
    :math:`ABC` edge is less than ``edge_width`` (the root square of
    ``edge_width_square``).


.. c:function:: int triangle2d_on_edges(CTriangle2D* ABC, CPoint2D* P, double edge_width_square)

    Test if point :math:`P` is on one of the edge of triangle :math:`ABC`.

    :math:`P` will be considered to be on one of the edge of triangle
    :math:`ABC`.  if distance between :math:`P` and one of :math:`ABC` edge is
    less than ``edge_width`` (the root square of ``edge_width_square``).

    Returns:
        - 0 if :math:`P` is on edge :math:`[AB]`,
        - 1 if :math:`P` is on edge :math:`[BC]`,
        - 2 if :math:`P` is on edge :math:`[CA]`,
        - -2 if :math:`P` is not on any edge.


.. c:function:: double triangle2d_signed_area(CTriangle2D* T)

    Compute the signed area of triangle :math:`T`.

    Triangle area is the absolute value of the signed area.

    - If signed area is positive, triangle is counterclockwise.

    - If signed area is negative, triangle is clockwise.

    - If signed area is zero, triangle is degenerated.


.. c:function:: double triangle2d_area(CTriangle2D* T)

    Compute the area of triangle :math:`T`.


.. c:function:: void triangle2d_center(CTriangle2D* T, CPoint2D* C)

    Compute the center :math:`C` of triangle :math:`T`.

    Variable ``C`` must be already allocated.


.. c:function:: void triangle2d_gradx_grady_det(CTriangle2D* tri, double signed_area, double gradx[3], double grady[3], double det[3])

    Compute factors for linear interpolation of data defined on triangle
    vertices :math:`A`, :math:`B` and :math:`C` to points included in the
    triangle.
