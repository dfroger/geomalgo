import unittest
from math import sqrt

from numpy.testing import assert_allclose

import geomalgo as ga


STEP = ga.data.step


class TestUtil(unittest.TestCase):

    def test_centers(self):
        TG = ga.Triangulation2D(STEP.x, STEP.y, STEP.trivtx)

        xcenter, ycenter = ga.triangulation.compute_centers(TG)

        a = 1/3
        b = 2/3
        assert_allclose(xcenter, [a, 1.5, b, 2, a, b])
        assert_allclose(ycenter, [10+a, 10+a, 10+b, 10+b, 11+a, 11+b])

    def test_signed_area(self):
        # make some triangle clockwise to have negative signed area
        trivtx = STEP.trivtx.copy()
        trivtx[0, 0], trivtx[0, 1] = trivtx[0, 1], trivtx[0, 0]
        trivtx[1, 1], trivtx[1, 2] = trivtx[1, 2], trivtx[1, 1]

        TG = ga.Triangulation2D(STEP.x, STEP.y, trivtx)

        signed_area = ga.triangulation.compute_signed_area(TG)

        assert_allclose(signed_area, [-0.5, -0.75, 0.5, 0.75, 0.5, 0.5])

    def test_compute_bounding_box(self):
        TG = ga.Triangulation2D(STEP.x, STEP.y, STEP.trivtx)
        bb = ga.triangulation.compute_bounding_box(TG)

        self.assertEqual(bb.xmin, 0)
        self.assertEqual(bb.xmax, 2.5)

        self.assertEqual(bb.ymin, 10)
        self.assertEqual(bb.ymax, 12)

    def test_compute_edge_min_max(self):
        TG = ga.Triangulation2D(STEP.x, STEP.y, STEP.trivtx)
        edge_min, edge_max = ga.triangulation.compute_edge_min_max(TG)

        self.assertAlmostEqual(edge_min, 1)
        self.assertAlmostEqual(edge_max, sqrt(3.25))


if __name__ == '__main__':
    unittest.main()
