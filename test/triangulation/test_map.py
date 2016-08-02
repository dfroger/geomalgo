import unittest

import numpy as np

#  3-------4-------5
#  | \     | \     |
#  |   \   |   \   |
#  |     \ |     \ |
#  0-------1-------2

class EdgeMap:

    def __init__(self):
        self.bounds = np.array(
        #     | 0 | 1 | 2 | 3 | 4 |     V0
            [ 0 , 2 , 5 , 7 , 8 , 9 ]
        )

        self.edges = np.array(
        #   |   0   |     1     |   2   | 3 | 4 |    V0
        #   0       2           5       7   8   9    bounds
            [ 1 , 3 , 2 , 3 , 4 , 4 , 5 , 4 , 5 ]  # V1
        )

        self.is_intern  = np.array(
        #   |   0   |     1     |   2   | 3 | 4 |
            [ 0 , 0 , 0 , 1 , 1 , 1 , 0 , 0 , 0 ]
        )

        self.idx = np.array(
        #   |   0   |     1     |   2   | 3 | 4 |
            [ 0 , 5 , 1 , 0 , 1 , 2 , 2 , 4 , 3 ]
        )

    def __getitem__(self, V0V1):
        V0, V1 = V0V1
        if V0 > V1:
            V0, V1 = V1, V0

        B, C = self.bounds[V0], self.bounds[V0+1]

        for I in range(B, C):
            if self.edges[I] == V1:
                break
        else:
            raise IndexError("No such edge: ({}, {})".format(V0, V1))

        return self.is_intern[I], self.idx[I]


class BoundaryEdges:

    def __init__(self):

        self.vertices = np.array(
        #    0  1  2  3  4  5  6
            [0, 1, 2, 5, 4, 3, 0]
        )

class InternEdges:

    def __init__(self):
        self.vertices = np.array([
            [1, 3], [1, 4], [2, 4]
        ])


class TestEdgeMap(unittest.TestCase):

    def setUp(self):
        self.edge_map = EdgeMap()
        self.boundary_edges = BoundaryEdges()
        self.intern_edges = InternEdges()

    def test_intern(self):
        is_intern, I = self.edge_map[(2, 4)]
        self.assertTrue(is_intern)
        V0, V1 = self.intern_edges.vertices[I]
        self.assertEqual(V0, 2)
        self.assertEqual(V1, 4)

if __name__ == '__main__':
    unittest.main()

