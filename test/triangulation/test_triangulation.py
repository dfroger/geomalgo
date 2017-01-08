import unittest

from numpy.testing import assert_allclose

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

    def test_centers(self):
        TG = ga.Triangulation2D(STEP.x, STEP.y, STEP.trivtx)

        self.assertIsNone(TG.xcenter)
        self.assertIsNone(TG.ycenter)

        TG.compute_centers()

        a = 1/3
        b = 2/3
        assert_allclose(TG.xcenter, [a, 1.5, b, 2, a, b])
        assert_allclose(TG.ycenter, [10+a, 10+a, 10+b, 10+b, 11+a, 11+b])

    def test_signed_area(self):
        # make some triangle clockwise to have negative signed area
        trivtx = STEP.trivtx.copy()
        trivtx[0, 0], trivtx[0, 1] = trivtx[0, 1], trivtx[0, 0]
        trivtx[1, 1], trivtx[1, 2] = trivtx[1, 2], trivtx[1, 1]

        TG = ga.Triangulation2D(STEP.x, STEP.y, trivtx)

        self.assertIsNone(TG.signed_area)

        TG.compute_signed_area()

        assert_allclose(TG.signed_area, [-0.5, -0.75, 0.5, 0.75, 0.5, 0.5])

    def test_to_numpy(self):
        TG = ga.Triangulation2D(STEP.x, STEP.y, STEP.trivtx)
        x, y, trivtx = TG.to_numpy()

    def test_to_matplotlib(self):
        TG = ga.Triangulation2D(STEP.x, STEP.y, STEP.trivtx)
        tri = TG.to_matplotlib()

if __name__ == '__main__':
    unittest.main()
