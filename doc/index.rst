GeomAlgo documentation
======================

``geomalgo`` aims at prodiving basic geometric 2D and 3D algorithms, for
example computing the area of 2D triangle, or finding intersection points of
3D triangle and a 3D segment.

``geomalgo`` algorithms are primary based on `geomalgorithms
<http://geomalgorithms.com>`_.

``geomalgo`` provides a convenient Python API, and a Cython API to obtain ``C``
performances, typically for computation inside loops.

Get started with the examples gallery, and read the details in API section.

Installation
------------

`Install <http://conda.pydata.org/miniconda.html>`_ the `Conda
<http://conda.pydata.org>`_ package manager, and install ``geomalgo`` with:

.. code-block:: bash

    conda install -c dfroger geomalgo

Documentation
-------------

.. toctree::
    :maxdepth: 1

    tuto/index
    python/index
    cython/index
    devel

Development and contact
-----------------------

``geomalgo`` is developed on `GitHub <https://github.com/dfroger/geomalgo>`_,
were issues and pull requests can be made. Or do not hesitate to send me an
email at david.froger@mailoo.org .

How it looks
------------

.. plot::
    :include-source:

    from pylab import *
    import geomalgo as ga

    A = ga.Point2D(0, 0, name='A')
    B = ga.Point2D(4, 0, name='B')
    C = ga.Point2D(2, 4, name='C')

    ABC = ga.Triangle2D(A, B, C)

    figure(figsize=(4,4))

    A.plot()
    B.plot()
    C.plot()
    ABC.plot()

    text(ABC.center.x, ABC.center.y,
         'area = {}'.format(ABC.area), ha='center')

    xlim(-1, 5)
    ylim(-1, 5)
    show()
