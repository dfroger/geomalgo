import unittest

import numpy as np
from numpy.testing import assert_equal

import geomalgo as ga


class TestTriangleToCell(unittest.TestCase):

    def test_four_cells(self):
        """
            25  +-----+-----+-----+-----+
                |     |     |     |     |
                |     |   B |     |     |
                |     |  /|\|     |     |
                |8    | / | \     |   11|
            20  +-----+/--|-+\----+-----+
                |     /   | | \   |     |
                |    /|  1|0|  \  |     |
                |   C-----E-----A |     |   Triangles    Center
                |4   \|  2|3|  /  |    7|   0 ABE        (12, 19)
            15  +-----\---|-+-/---+-----+   1 BCE        ( 8, 19)
                |     |\  | |/    |     |   2 CDE        ( 8, 15)
                |     | \ | /     |     |   3 DAE        (12, 15)
                |     |  \|/|     |     |
                |0    |   D |     |    3|
            10  +-----+-----+-----+-----+
                0     6    12    18    24

        """

        A = ga.Point2D(16, 17, 0)
        B = ga.Point2D(10, 23, 1)
        C = ga.Point2D( 4, 17, 2)
        D = ga.Point2D(10, 11, 3)
        E = ga.Point2D(10, 17, 4)

        points = [A, B, C, D, E]
        x = np.asarray([P.x for P in points])
        y = np.asarray([P.y for P in points])

        triangles = [(A,B,E), (B,C,E), (C,D,E), (D,A,E)]
        trivtx = np.asarray([[P.index for P in vertices]
                            for vertices in triangles], dtype='int32')

        TG = ga.Triangulation2D(x, y, trivtx)
        grid = ga.Grid2D(0, 24, 4, 10, 25, 3)

        ix_min = np.zeros(4, dtype='int32')
        ix_max = np.zeros(4, dtype='int32')
        iy_min = np.zeros(4, dtype='int32')
        iy_max = np.zeros(4, dtype='int32')

        ga.build_triangle_to_cell(ix_min, ix_max, iy_min, iy_max,
                               TG, grid, 0.01)

        assert_equal(ix_min, [1, 0, 0, 1])
        assert_equal(ix_max, [2, 1, 1, 2])
        assert_equal(iy_min, [1, 1, 0, 0])
        assert_equal(iy_max, [2, 2, 1, 1])


class TestBuildCellToTriangle(unittest.TestCase):

    def test_four_cells(self):
        """
        same geometry as TestTriangleToCell.test_four_cells
        """

        ix_min = np.array([1, 0, 0, 1], dtype='int32')
        ix_max = np.array([2, 1, 1, 2], dtype='int32')
        iy_min = np.array([1, 1, 0, 0], dtype='int32')
        iy_max = np.array([2, 2, 1, 1], dtype='int32')

        nx, ny = 4, 3

        celltri, celltri_idx = ga.build_cell_to_triangle(ix_min, ix_max,
                                                         iy_min, iy_max,
                                                         nx, ny)

        assert_equal(celltri, [
            2,           # cell  0     0: 1
            2, 3,        # cell  1     1: 3
            3,           # cell  2     3: 4
                         # cell  3     4: 4
            1, 2,        # cell  4     4: 6
            0, 1, 2, 3,  # cell  5     6:10
            0, 3,        # cell  6    10:12
                         # cell  7    12:12
            1,           # cell  8    12:13
            0, 1,        # cell  9    13:15
            0,           # cell 10    15:16
                         # cell 11    16:16
        ])

        assert_equal(celltri_idx,
                     [0, 1, 3, 4, 4, 6, 10, 12, 12, 13, 15, 16, 16])

if __name__ == '__main__':
    unittest.main()
