import unittest

import numpy as np
from numpy.testing import assert_equal

from geomalgo import Triangulation2D, Grid2D, build_triangle_to_cell, Point2D


class TestTriangleToCell(unittest.TestCase):

    def test_four_cells(self):
        """
            25  +-----+-----+-----+
                |     |     |     |
                |     |   B |     |
                |     |  /|\|     |
                |     | / | \     |
            20  +-----+/--|-+\----+
                |     /   | | \   |
                |    /|   | |  \  |
                |   C-----E-----A |   Triangles    Center
                |    \|   | |  /  |   ABE          (12, 19)
            15  +-----\---|-+-/---+   BCE          ( 8, 19)
                |     |\  | |/    |   CDE          ( 8, 15)
                |     | \ | /     |   DAE          (12, 15)
                |     |  \|/|     |
                |     |   D |     |
            10  +-----+-----+-----+
                0     6    12    18

        """

        A = Point2D(16, 17, 0)
        B = Point2D(10, 23, 1)
        C = Point2D( 4, 17, 2)
        D = Point2D(10, 11, 3)
        E = Point2D(10, 17, 4)

        points = [A, B, C, D, E]
        x = np.asarray([P.x for P in points])
        y = np.asarray([P.y for P in points])

        triangles = [(A,B,E), (B,C,E), (C,D,E), (D,A,E)]
        trivtx = np.asarray([[P.index for P in vertices]
                            for vertices in triangles], dtype='int32')

        TG = Triangulation2D(x, y, trivtx)
        grid2d = Grid2D(0, 18, 3, 10, 25, 3)

        ix_min = np.zeros(4, dtype='int32')
        ix_max = np.zeros(4, dtype='int32')
        iy_min = np.zeros(4, dtype='int32')
        iy_max = np.zeros(4, dtype='int32')

        build_triangle_to_cell(ix_min, ix_max, iy_min, iy_max,
                               TG, grid2d, 0.01)

        assert_equal(ix_min, [1, 0, 0, 1])
        assert_equal(ix_max, [2, 1, 1, 2])
        assert_equal(iy_min, [1, 1, 0, 0])
        assert_equal(iy_max, [2, 2, 1, 1])

    def test_around_cell(self):
        """
        Case of a triangle vertices around a cell

        +---+---+---+
        | 3 | 4 | 5 |
        |  A-----B  |
        |   \   /   |
        +---+\-/+---+
        |   | C |   |
        | 0 | 1 | 2 |
        |   |   |   |
        +---+---+---+
        """
        pass
#
# **************************************************
# Example with triangle edges greater than cell side
# **************************************************
#
# Legend:
#    A B C D position of triangle vertices
#    +       position of cell vertices
#    :       vertical cell edges
#    .       horizontal cell edges
#    - \     triangle edges
#
#   iy
#      +...+...+...+...+...+...+...+...+...+
#    6 :   :   :   :   :   :   :   :   :   :
#      +...+...+...+...+...+...+...+...+...+
#    5 :   :       :C---------------D  :   :
#      +...+...+.../.\.+...+...+.../...+...+
#    4 :   :   :  /:  \:   : X :  /:   :   :
#      +...+...+./.+...\...+...+./.+...+...+
#    3 :   :   :/  :   :\  :   :/  :   :   :
#      +...+.../...+...+.\.+.../...+...+...+
#    2 :   :  /:   :   :  \:  /:   :   :   :
#      +...+./.+...+...+...\./.+...+...+...+
#    1 :   :A---------------B  :   :   :   :
#      +...+...+...+...+...+...+...+...+...+
#    0 :   :   :   :   :   :   :   :   :   :
#      +...+...+...+...+...+...+...+...+...+
#        0   1   2   3   4   5   6   7   8  ix
#
#    When looping on triangle ABC, the 25 cells delimited by iy=1...5 and
#    ix=1...5 are associated to triangle ABC.
#
#    When looping on triangle BCD, the 25 cells delimited by iy=1...5 and
#    ix=3...7 are associated to triangle BCD.
#
#    So, when searching in which triangle the point X is, it will be searched
#    in both ABC and BCD.
#
# ***********************************************
# Example with triangle edges less than cell side
# ***********************************************

# Each triangle is to be search in 1, 2, 3 or 4 cells. There are
# 6 different cases, drawn bellow.
#
# Legend:
#    A, B, C  position of triangle vertices.
#    +        position of cell vertices
#    -        horizontal cell edges
#    |        vertical cell edges
#    x        cell edge and triangle edge intersections
#    # ~      cell that do not overlap with triangles
#
# A, B and C all in the same cell.
# ================================
#
#       0) 1 cell
#    +------+------+
#    | A  C |######|
#    |      |######|
#    | B    |######|
#    +------+------+
#    |######|######|
#    |######|######|
#    |######|######|
#    +------+------+
#
# A and B in one cell, C in another.
# ==================================
#
#       1) 2 cells        2) 3 cells         3) 4 cells
#    +------+------+    +------+------+    +------+------+
#    |   A  x   C  |    |    A |      |    |    A |      |
#    |      x      |    |    B x      |    |      x      |
#    |   B  |      |    |      x      |    | B    |      |
#    +------+------+    +------+--xx--+    +---x--+-x----+
#    |######|######|    |~~~~~~|    C |    |      x      |
#    |######|######|    |~~~~~~|      |    |      |   C  |
#    |######|######|    |~~~~~~|      |    |      |      |
#    +------+------+    +------+------+    +------+------+
#
# A, B and C all in different cells.
# ==================================
#
#      4) 3 cells         5) 4 cells
#    +------+------+    +------+------+
#    | A    x C    |    |      |      |
#    |      x      |    |   A  x    C |
#    |      |      |    |      |      |
#    +-x--x-+------+    +---x--+-x----+
#    |      |~~~~~~|    |      x      |
#    | B    |~~~~~~|    |      |      |
#    |      |~~~~~~|    |   B  |      |
#    +------+------+    +------+------+
