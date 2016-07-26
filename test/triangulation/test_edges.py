import unittest

import numpy as np
from numpy.testing import assert_equal

from geomalgo import build_edges

# 6-------7
# | \  T5 |
# |   \   |
# | T4  \ |
# 3-------4-------5
# | \  T2 | \  T3 |
# |   \   |   \   |
# | T0  \ | T1  \ |
# 0-------1-------2
trivtx = np.array([
    [0, 1, 3], [1, 2, 4], # T0, T1
    [1, 4, 3], [2, 5, 4], # T2, T3
    [3, 4, 6], [4, 7, 6], # T4, T5
], dtype='int32')

NV = 9

class TestEdges(unittest.TestCase):

    def test_normal(self):
        intern_edges, boundary_edges = build_edges(trivtx, NV)

        self.assertEqual(intern_edges.vertices.shape, (5,2))
        assert_equal(intern_edges.vertices[0], (1, 3))

if __name__ == '__main__':
    unittest.main()
