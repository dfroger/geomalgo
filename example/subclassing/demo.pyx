from geomalgo cimport Point2D

from vertice cimport Vertice
from cell cimport Cell

def demo():
    A = Vertice(0, 0, 0.5)
    B = Vertice(1, 0, 0.5)
    C = Vertice(0, 1, 0.5)

    cell = Cell(A, B, C, alpha=0.5)

    cell.A.to_polar()
    cell.A.meth()

    P = Point2D(0.25, 0.25)

    cell.includes_point(P)
