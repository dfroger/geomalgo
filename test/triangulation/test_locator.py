import unittest

import numpy as np
from numpy.testing import assert_equal

import geomalgo as ga

HOLE = ga.data.hole


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
        assert_equal(ix_max, [3, 2, 2, 3])
        assert_equal(iy_min, [1, 1, 0, 0])
        assert_equal(iy_max, [3, 3, 2, 2])


class TestBuildCellToTriangle(unittest.TestCase):

    def test_four_cells(self):
        """
        same geometry as TestTriangleToCell.test_four_cells
        """

        ix_min = np.array([1, 0, 0, 1], dtype='int32')
        ix_max = np.array([3, 2, 2, 3], dtype='int32')
        iy_min = np.array([1, 1, 0, 0], dtype='int32')
        iy_max = np.array([3, 3, 2, 2], dtype='int32')

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


class TestTriangulationLocator(unittest.TestCase):

    def test_tri_center(self):
        """
        Check that center of triangles of found in their triangles
        """

        # Triangle centers.
        xcenter = np.average(HOLE.x[HOLE.trivtx], axis=1)
        ycenter = np.average(HOLE.y[HOLE.trivtx], axis=1)
        NP = len(xcenter)

        nx, ny = 5, 5
        edge_width = 1.E-07

        locator = ga.TriangulationLocator(HOLE.triangulation,
                                          nx, ny, edge_width)

        triangles = np.empty(NP, dtype='int32')
        nout = locator.search_points(xcenter, ycenter, triangles)

        self.assertEqual(nout, 0)
        assert_equal(triangles, np.arange(NP))

    def test_hole_aligned(self):
        """
        The grid is aligned on triangle vertical and horizontal edges.

        In particular, we test that the two hole cells have the triangle
        associated, so a point on hole edge is detected.

             y grid.iy
             ^   ^
             |   |
            15     28----------29----------30----------31
                    |\         /|\         /|\         /|
                    | \  33   / | \  36   / | \  39   / |
            14   3  |  \     /  |  \     /  |  \     /  |
                    |32 \   / 34|35 \   / 37|38 \   / 40|
                    |    \ /    |    \ /    |    \ /    |
            13     21----22----23----24----25----26----27
                    |28 / |29 / |           | \ 30| \ 31|
                 2  | / 12| / 13|           | 14\ | 15\ |
            12     14----15----16----17----18----19----20
                    |22 / |23 / |24 / | \ 25| \ 26| \ 27|
                 1  | / 6 | / 7 | / 8 |9  \ |10 \ |11 \ |
            11      7-----8-----9----10----11----12----13
                    |16 / |17 / |18 / | \ 19| \ 20| \ 21|
                 0  | / 0 | / 1 | / 2 |3  \ |4  \ |5  \ |
            10      0-----1-----2-----3-----4-----5-----6
                       0     1     2     3     4     5       -> grid.ix
                    0     1     2     3     4     5     6    -> x
        """
        nx, ny = 6, 5
        edge_width = 1.E-07

        locator = ga.TriangulationLocator(HOLE.triangulation,
                                          nx, ny, edge_width)

        # top bottom cell
        self.assertEqual(locator.cell_to_triangles(0, 0),
                         {0, 16, 1, 17, 7, 23, 6, 22})

        # left hole cell
        # triangle 33 is included because its cell range is searched in
        # square of points [21, 23, 29, 28]. An optimisation would be to
        # detect it does not overlap with cell (2, 2).
        self.assertEqual(locator.cell_to_triangles(2, 2),
                         {9, 25, 8, 24, 7, 23, 13, 29, 34, 35, 36, 37, 33})

        # right hole cell
        # triangle 39 is included for the same reason of triangle 33 above.
        self.assertEqual(locator.cell_to_triangles(3, 2),
                         {8, 24, 9, 25, 10, 26, 14, 30, 38, 37, 36, 35, 39})

    def test_points_out(self):
        """
                                      E

                15  28----------29----------30----------31
                     |\         /|\         /|\         /|
                     | \  33   / | \  36   / | \  39   / |
                14   |  \     /  |  \     /  |  \     /  |
                     |32 \   / 34|35 \   / 37|38 \   / 40|
                     |    \ /    |    \ /    |    \ /    |
                13  21----22----23----24----25----26----27
                     |28 / |29 / | A     B   | \ 30| \ 31|
                     | / 12| / 13|           | 14\ | 15\ |
           F    12  14----15----16----17----18----19----20    D
                     |22 / |23 / |24 / | \ 25| \ 26| \ 27|
                     | / 6 | / 7 | / 8 |9  \ |10 \ |11 \ |
                11   7-----8-----9----10----11----12----13
                     |16 / |17 / |18 / | \ 19| \ 20| \ 21|
                     | / 0 | / 1 | / 2 |3  \ |4  \ |5  \ |
                10   0-----1-----2-----3-----4-----5-----6

                     0     1     2     3     4     5     6

                                       C
        """

        # Points out of the domain
        A = ga.Point2D( 2.5, 12.5)
        B = ga.Point2D( 3.5, 12.5)
        C = ga.Point2D( 3  ,  9  )
        D = ga.Point2D(-1  , 12  )
        E = ga.Point2D( 3  , 16  )
        F = ga.Point2D( 7  , 12  )

        points = [A, B, C, D, E, F]
        NP = len(points)

        x = np.array([P.x for P in points])
        y = np.array([P.x for P in points])

        nx, ny = 5, 5
        edge_width = 1.E-07

        locator = ga.TriangulationLocator(HOLE.triangulation,
                                          nx, ny, edge_width)

        triangles = np.full(NP, fill_value=-2, dtype='int32')
        nout = locator.search_points(x, y, triangles)
        self.assertEqual(nout, NP)

        assert_equal(triangles, np.full(NP, fill_value=-1, dtype='int32'))

if __name__ == '__main__':
    unittest.main()
