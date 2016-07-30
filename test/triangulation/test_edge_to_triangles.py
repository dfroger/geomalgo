import unittest

import numpy as np

from geomalgo import EdgeToTriangles
from geomalgo.data import step, hole

class TestStep(unittest.TestCase):

    def test_normal(self):
        edge2tri = EdgeToTriangles(step.trivtx, step.NV)

        self.assertEqual(edge2tri.NB, step.NB)
        self.assertEqual(edge2tri.NI, step.NI)
        self.assertEqual(edge2tri.NE, step.NE)

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
        edge2tri = EdgeToTriangles(step.trivtx, step.NV)
        self.assertEqual(edge2tri[(4,2)], (1, 3))

    def test_wrong_key(self):
        edge2tri = EdgeToTriangles(step.trivtx, step.NV)
        with self.assertRaisesRegex(KeyError, "No such edge"):
            edge2tri[(3,7)]

class TestHole(unittest.TestCase):

    def test_normal(self):
        edge2tri = EdgeToTriangles(hole.trivtx, hole.NV)

        self.assertEqual(edge2tri.NB, hole.NB)
        self.assertEqual(edge2tri.NI, hole.NI)
        self.assertEqual(edge2tri.NE, hole.NE)

if __name__ == '__main__':
    unittest.main()
