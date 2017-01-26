import unittest

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

if __name__ == '__main__':
    unittest.main()
