import pyximport; pyximport.install()

from geomalgo import Point2D

from vertice import Vertice
from cell import Cell

A = Vertice(0, 0, 0.5)
B = Vertice(1, 0, 0.5)
C = Vertice(0, 1, 0.5)

cell = Cell(A, B, C, alpha=0.5)

print(cell.A.to_polar())
print(cell.A.meth())


P = Point2D(0.25, 0.25)

print(cell.includes_point(P))
