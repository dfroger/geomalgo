import unittest

import numpy as np

from geomalgo import (
    Point2D, Grid2D, compute_index, compute_row_col, coord_to_index
)

from geomalgo.data import step


class TestCoordToIndex(unittest.TestCase):

    def test_normal(self):
        """Test index is computed from coordinate"""
        #  -2   -1.5   -1   -0.5    0    0.5    1    1.5    2
        #   |     |     |     |     |     |     |     |     |
        #   |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
        minval = -2
        delta = 0.5

        self.assertEqual(coord_to_index( 0.75, minval, delta), 5)
        self.assertEqual(coord_to_index(-0.75, minval, delta), 2)


class TestComputeIndex(unittest.TestCase):

    def test_normal(self):
        """Test cell index is computed from cell ix and iy"""
        #  iy
        #     +---+---+---+
        #   1 | 3 | 4 | 5 |
        #     +---+---+---+
        #   0 | 0 | 1 | 2 |
        #     +---+---+---+
        #       0   1   2   ix
        nx = 3

        self.assertEqual(compute_index(nx, 0, 0), 0)
        self.assertEqual(compute_index(nx, 1, 0), 1)
        self.assertEqual(compute_index(nx, 2, 0), 2)

        self.assertEqual(compute_index(nx, 0, 1), 3)
        self.assertEqual(compute_index(nx, 1, 1), 4)
        self.assertEqual(compute_index(nx, 2, 1), 5)


class TestComputeRowCol(unittest.TestCase):

    def test_normal(self):
        """Test cell ix and iy are computed from cell index"""
        #  iy
        #     +---+---+---+
        #   1 | 3 | 4 | 5 |
        #     +---+---+---+
        #   0 | 0 | 1 | 2 |
        #     +---+---+---+
        #       0   1   2   ix

        nx = 3

        self.assertEqual(compute_row_col(0, nx), (0, 0))
        self.assertEqual(compute_row_col(1, nx), (1, 0))
        self.assertEqual(compute_row_col(2, nx), (2, 0))

        self.assertEqual(compute_row_col(3, nx), (0, 1))
        self.assertEqual(compute_row_col(4, nx), (1, 1))
        self.assertEqual(compute_row_col(5, nx), (2, 1))


class TestGrid2D(unittest.TestCase):

    def test_find_cell(self):
        """Test the cell containing a point is found"""
        #     iy
        #  30    +-------+-------+-------+-------+
        #        |     4 |     5 |     6 |     7 |
        #      1 |       |       |   P   |       |
        #        |       |       |       |       |
        #  20    +-------+-------+-------+-------+
        #        |     0 |     1 |     2 |     3 |
        #      0 |   Q   |       |       |       |
        #        |       |       |       |       |
        #  10    +-------+-------+-------+-------+
        #        -1      -0.5    0       0.5     1
        #            0       1       2       3     ix

        grid = Grid2D(xmin=-1, xmax=1.0, nx=4, ymin=10, ymax=30, ny=2)
        P = Point2D(0.25, 25)
        Q = Point2D(-0.75, 15)

        cell = grid.find_cell(P)
        self.assertEqual(cell.ix, 2)
        self.assertEqual(cell.iy, 1)
        self.assertEqual(cell.index, 6)

        cell = grid.find_cell(Q)
        self.assertEqual(cell.ix, 0)
        self.assertEqual(cell.iy, 0)
        self.assertEqual(cell.index, 0)

    def test_from_triangulation(self):
        """Test a grid is created from a triangulation"""
        grid = Grid2D.from_triangulation(step.triangulation, 5, 4)

        self.assertEqual(grid.xmin,  0.)
        self.assertEqual(grid.xmax,  2.5)
        self.assertEqual(grid.nx, 5)

        self.assertEqual(grid.ymin, 10.)
        self.assertEqual(grid.ymax, 12.)
        self.assertEqual(grid.ny, 4)

        self.assertAlmostEqual(grid.dx, 0.5)
        self.assertAlmostEqual(grid.dy, 0.5)


if __name__ == '__main__':
    unittest.main()
