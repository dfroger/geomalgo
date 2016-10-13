from ..base2d cimport CPoint2D, CPolygon2D, c_is_left, new_point2d

cdef int polygon2d_winding_point2d(CPolygon2D* PG, CPoint2D* P):
    """
    Winding number test for a point in a polygon.

    If windning_number is 0, point is outside.
    If winding_number is different from 0, point is inside.

    http://geomalgorithms.com/a03-inclusion.html

    Example:

     4  C
        |\
     3  |   \         O (3,3)
        |      \
     2  |         \
        |            \
     1  |    I (1,1)    \
        |                  \
     0  A-------------------B
        0    1    2    3    4

    Point O:
        AB: no upward nor downward crossing
        BC: upward crossing, but not left
        CA: downward crossing, but not right
        -> winding_number is 0

    Point I:
        AB: no upward nor downward crossing
        BC: upward crossing, is left: +1
        CA: downward crossing, but not right
        -> winding number is +1

    """
    cdef:
        int winding_number = 0
        size_t i
        CPoint2D A
        CPoint2D B

    # Loop through all edges [AB] of the polygon.
    for i in range(PG.points_number - 1):
        A.x, A.y = PG.x[i  ], PG.y[i  ]
        B.x, B.y = PG.x[i+1], PG.y[i+1]

        if A.y <= P.y:
            if P.y < B.y:
                # A.y <= P.y < B.y: Upward crossing.
                # Now, test if P is left AB
                if c_is_left(&A, &B, P) > 0:
                    winding_number += 1

        else:
            if B.y <= P.y:
                # B.y <= P.y < A.y: Downward crossing
                # Now, test if P is right AB
                if c_is_left(&A, &B, P) < 0:
                     winding_number -= 1

    return winding_number
