from geomalgo import Point2D, Segment2D

"""
4        S
         |
3  P-----I--Q
         |
1        |
         |
0        R
   0  1  2  3
"""

# Initialize segment PQ
P = Point2D(0., 3.)
Q = Point2D(3., 3.)
PQ = Segment2D(P, Q)

# Initialize segment RS
R = Point2D(2., 0.)
S = Point2D(2., 4.)
RS = Segment2D(R, S)

# Compute segment intersection
I0, I1 = PQ.intersect_segment(RS)

print("Intersection: x = {}, y = {}".format(I0.x, I0.y))
