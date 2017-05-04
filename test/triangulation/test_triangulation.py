import unittest

import numpy as np

import geomalgo as ga


STEP = ga.data.step


class TestTriangulation(unittest.TestCase):

    def test_get(self):
        TG = ga.Triangulation2D(STEP.x, STEP.y, STEP.trivtx)

        triangle = TG[3]

        self.assertEqual(triangle.index, 3)

        self.assertEqual(triangle.A.x, 2.5)
        self.assertEqual(triangle.A.y,  10)

        self.assertEqual(triangle.B.x, 2.5)
        self.assertEqual(triangle.B.y,  11)

        self.assertEqual(triangle.C.x, 1)
        self.assertEqual(triangle.C.y, 11)

        self.assertAlmostEqual(triangle.area, 0.75)

    def test_to_numpy(self):
        TG = ga.Triangulation2D(STEP.x, STEP.y, STEP.trivtx)
        x, y, trivtx = TG.to_numpy()

    def test_to_matplotlib(self):
        TG = ga.Triangulation2D(STEP.x, STEP.y, STEP.trivtx)
        tri = TG.to_matplotlib()

    def test_x_y_have_different_length(self):
        x = np.array( STEP.x.tolist() + [0, ] )
        msg = 'Vector x and y must have the same length, but got 9 and 8'
        with self.assertRaisesRegex(ValueError, msg):
            ga.Triangulation2D(x, STEP.y, STEP.trivtx)

    def test_trivtx_has_bad_shape(self):
        trivtx = STEP.trivtx.copy()
        NT = trivtx.shape[0]
        trivtx.shape = (3, NT)
        msg = 'trivtx must be an array of shape \(NT, 3\), but got: \(3, 6\)'
        with self.assertRaisesRegex(ValueError, msg):
            ga.Triangulation2D(STEP.x, STEP.y, trivtx)

if __name__ == '__main__':
    unittest.main()
