from geomalgo cimport CPoint2D, CSegment2D, intersect_segment2d_segment2d

def demo():
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
    cdef:
        CPoint2D P, Q, R, S, I0, I1
        CSegment2D PQ, RS
        int n
        double coords[4]

    # Initialize segment PQ
    P.x, P.y = 0., 3.
    Q.x, Q.y = 3., 3.
    PQ.A = &P
    PQ.B = &Q

    # Initialize segment RS
    R.x, R.y = 2., 0.
    S.x, S.y = 2., 4.
    RS.A = &R
    RS.B = &S

    # Compute segment intersection
    n = intersect_segment2d_segment2d(&PQ, &RS, &I0, &I1, coords)

    print("Number of intersection points: {}".format(n))
    print("Intersection: x = {}, y ={}".format(I0.x, I0.y))
    print("Intersection: parametric coord on PQ = {}".format(coords[0]))
    print("Intersection: parametric coord on RS = {}".format(coords[1]))
