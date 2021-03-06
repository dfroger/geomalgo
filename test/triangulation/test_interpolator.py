import unittest

import numpy as np

import geomalgo as ga

HOLE = ga.data.hole

class TestTriangulationInterpolator(unittest.TestCase):

    def test_normal(self):

        def linear_function(x,y):
            """Use a linear function, so linear interpolation will be exact"""
            return -4*np.asarray(x) + 7*np.asarray(y) - 16

        # Create triangulation and a locator.
        TG = ga.Triangulation2D(HOLE.x, HOLE.y, HOLE.trivtx)
        locator = ga.TriangulationLocator(TG)

        # Create interpolator to triangle centers.
        interpolator = ga.TriangulationInterpolator(TG, locator, TG.NT)
        xcenter, ycenter = ga.triangulation.compute_centers(TG)
        nout = interpolator.set_points(xcenter, ycenter)
        self.assertEqual(nout, 0)

        # Compute data on mesh vertices, and expected data on triangle
        # centers.
        vertdata = linear_function(TG.x, TG.y)
        expected_pointdata = linear_function(xcenter, ycenter)

        # Interpolate data.
        pointdata = np.empty(TG.NT, dtype='d')
        interpolator.interpolate(vertdata, pointdata)

        # Check interpolated data.
        self.assertEqual(nout, 0)
        np.testing.assert_allclose(pointdata, expected_pointdata)

if __name__ == '__main__':
    unittest.main()

