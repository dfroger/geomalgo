import unittest

import numpy as np

from geomalgo import EdgeToTriangles

trivtx = np.array([
    [0, 1, 3], [1, 2, 4], # T0, T1
    [1, 4, 3], [2, 5, 4], # T2, T3
    [3, 4, 6], [4, 7, 6], # T4, T5
], dtype='int32')

NV = 9

class TestEdgeToTriangles(unittest.TestCase):

    """
    6-------7
    | \  T5 |
    |   \   |
    | T4  \ |
    3-------4-------5
    | \  T2 | \  T3 |
    |   \   |   \   |
    | T0  \ | T1  \ |
    0-------1-------2
    """

    def test_normal(self):

        edge2tri = EdgeToTriangles(trivtx, NV)

        self.assertEqual(edge2tri.NE, 13)
        self.assertEqual(edge2tri.NI,  5)
        self.assertEqual(edge2tri.NB,  8)

        expected = {
            (0, 1): (0, None),
            (0, 3): (0, None),
            (1, 2): (1, None),
            (1, 3): (0, 2),
            (1, 4): (1, 2),
            (2, 4): (1, 3),
            (2, 5): (3, None),
            (3, 4): (2, 4),
            (3, 6): (4, None),
            (4, 5): (3, None),
            (4, 7): (5, None),
            (4, 6): (4, 5),
            (6, 7): (5, None),
        }

        for V0V1, (T0, T1) in expected.items():
            self.assertEqual(edge2tri[V0V1], (T0, T1))

    def test_reversed_key(self):
        edge2tri = EdgeToTriangles(trivtx, NV)
        self.assertEqual(edge2tri[(4,2)], (1, 3))

    def test_wrong_key(self):
        edge2tri = EdgeToTriangles(trivtx, NV)
        with self.assertRaisesRegex(KeyError, "No such edge"):
            edge2tri[(3,7)]

if __name__ == '__main__':
    unittest.main()
