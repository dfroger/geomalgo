*************
BoundaryEdges
*************

Contruction
===========

.. py:function:: build_edges(trivtx, NV, intern_edges_order=None, boundary_edges_order=None)

    :param int[NT,3] trivtx: Triangle vertice indices.
    :param int NV: Number of vertices.

    It returns:
        a BoundaryEdges object
        a InternEdges object


Attributes
==========

.. py:attribute:: size: int

   Number of boundary edges in the triangulation.

.. py:attribute:: vertices: int[:,:]

.. py:attribute:: triangle: int[:]

.. py:attribute:: next_boundary_edge: int[:]

.. py:attribute:: label: int[:]

.. py:attribute:: length: double[:]

.. py:attribute:: normal: double[:,:]

.. py:attribute:: edge_map: EdgeMap
