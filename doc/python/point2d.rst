*******
Point2D
*******

The Point2D class represents points in two-dimensional space.

.. doctest::

    >>> import geomalgo as ga

    >>> A = ga.Point2D(2, 1, name='A')
    >>> B = ga.Point2D(6, 4, name='B')

Comute distance between two points:

    >>> A.distance(B)
    5

.. py:class:: Point2D(x: float, y:float)

   A point in two-dimensional space, of coordinates :math:`(x, y)`.

   .. py:attribute:: x: float

       First point coordiante

   .. py:attribute:: y: float

       First point coordiante

   .. py:method:: distance(self, other)

       Compute distance
