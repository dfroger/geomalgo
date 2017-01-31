***************
Triangulation2D
***************

See :ref:`tuto/triangulation_intro.ipynb` for a introduction on
:py:class:`Triangulation2D`.

Contruction
===========

.. py:class:: Triangulation2D(x, y, trivtx)

    :param double[NV] x: Vertice first coordinates.
    :param double[NV] y: Vertice second coordiantes.
    :param double[NT,3] trivtx: Triangle vertice indices.

Attributes
==========

:py:class:`Triangulation2D` has the following array attributes:

.. py:attribute:: x: double[NV]

    Vertice first coordinates.

.. py:attribute:: y: double[NV]

    Vertice second coordinates.

.. py:attribute:: trivtx: int[NT,3]

    Triangle vertice indices.

:py:class:`Triangulation2D` has the following array size attributes:

.. py:attribute:: NV: int

   The number of vertices

.. py:attribute:: NT: int

   The number of triangles

The main purpose of this extension type is to groups together the 3 arrays
that defines a triangulation in its attributes:

Methods
=======

:py:class:`Triangulation2D` has the following methods:

.. py:method:: __getitem__(self, triangle_index: int)

Return a Triangle2D instance
