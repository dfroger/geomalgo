from geomalgo import Point2D, Polygon2D

A = Point2D(0, 0)
B = Point2D(4, 0)
C = Point2D(0, 4)

P = Point2D(3, 3)

polygon = Polygon2D.from_points2d([A, B, C, A])

print(polygon.includes_point(P))
