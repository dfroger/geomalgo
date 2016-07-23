import unittest

import numpy as np

from geomalgo import EdgeToTriangles

trivtx = np.array([
    [0, 1, 3], [1, 2, 4], [1, 4, 3], [2, 5, 4], # T0, T1, T2, T3
    [3, 4, 6], [4, 5, 7], [4, 7, 6], [5, 7, 8], # T4, T5, T6, T7
], dtype='int32')

NV = 9

class TestEdgeToTriangles(unittest.TestCase):

    """
    6-------7-------8
    | \  T6 | \  T7 |
    |   \   |   \   |
    | T4  \ | T5  \ |
    3-------4-------5
    | \  T2 | \  T3 |
    |   \   |   \   |
    | T0  \ | T1  \ |
    0-------1-------2
    """

    def test_normal(self):

        edge_to_triangles = EdgeToTriangles(trivtx, NV)

        expected = {
            (0, 1): (0, None),
            (1, 2): (1, None),
            (3, 4): (2, 4),
            (4, 5): (3, 5),
            (6, 7): (6, None),
            (7, 8): (7, None),
            (0, 3): (0, None),
            (3, 6): (4, None),
            (1, 4): (1, 2),
            (4, 7): (5, 6),
            (2, 5): (3, None),
            (5, 8): (7, None),
            (1, 3): (0, 2),
            (2, 4): (1, 3),
            (4, 6): (4, 6),
            (5, 7): (5, 7),
        }

        for V0V1, (T0, T1) in expected.items():
            self.assertEqual(edge_to_triangles[V0V1], (T0, T1))

    def test_reversed_key(self):
        edge_to_triangles = EdgeToTriangles(trivtx, NV)
        self.assertEqual(edge_to_triangles[(4,2)], (1, 3))

    def test_wrong_key(self):
        edge_to_triangles = EdgeToTriangles(trivtx, NV)
        with self.assertRaisesRegex(KeyError, "No such edge"):
            edge_to_triangles[(4,8)]

if __name__ == '__main__':
    unittest.main()
