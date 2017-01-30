********
Vector2D
********


Structures
==========


.. c:type:: CVector2D

    .. c:member:: double x

        :math:`x` is the first vector component

    .. c:member:: double y

        :math:`y` is the second vector component


.. c:function:: CVector2D* new_vector2d()


.. c:function:: void del_vector2d(CVector2D* V)


Computational functions
=======================

.. c:function:: void vector2d_times_scalar(CVector2D *t, double alpha, CVector2D *u)

    Compute the vector :math:`\mathbf{t} = \alpha \mathbf{u}`

    ``t`` must be already allocated.


.. c:function:: void subtract_vector2d(CVector2D *AB, CVector2D *AC, CVector2D *BC)

    Compute the vector :math:`\mathbf{AB} = \mathbf{AC} - \mathbf{BC}`

    ``AB`` must be already allocated.


.. c:function:: void add_vector2d(CVector2D *AC, CVector2D *AB, CVector2D *BC)

    Compute the vector :math:`\mathbf{AC} = \mathbf{AB} + \mathbf{BC}`

    ``AC`` must be already allocated.


.. c:function:: double cross_product2d(CVector2D *u, CVector2D *v)

    Compute the cross product :math:`u_x v_y - u_y v_x` between
    vectors :math:`\mathbf{u}` and :math:`\mathbf{v}`.


.. c:function:: double dot_product2d(CVector2D *u, CVector2D *v)

    Compute the dot product :math:`u_x v_x + u_y v_y` between vectors
    :math:`\mathbf{u}` and :math:`\mathbf{v}`.


.. c:function:: double compute_norm2d(CVector2D *u)

    Compute the norm :math:`|\mathbf{u}| = \sqrt{u_x^2 + u_y^2}`.


.. c:function:: void normalize_vector2d(CVector2D *u)

    Normalize vector :math:`\mathbf{u}` so that its
    norm :math:`|\mathbf{u}|` is `1`.


.. c:function:: void compute_normal2d(CVector2D *n, CVector2D *u, double norm)

    Compute the unitary (:math:`|\mathbf{u}=1|` ) normal :math:`\mathbf{u}`
    of vector :math:`\mathbf{u}`.

    ``norm`` argument can be previously obtained with
    :c:func:`normalize_vector2d`

    ``n`` must be already allocated.
