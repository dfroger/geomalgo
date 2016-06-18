from ..base2d cimport CPoint2D, CPolygon2D, c_is_left, new_point2d

cdef int polygon2d_winding_point2d(CPolygon2D* PG, CPoint2D* P):
    """
    Winding number test for a point in a polygon.

    http://geomalgorithms.com/a03-inclusion.html
    """
    cdef:
        int winding_number = 0
        size_t i
        CPoint2D A
        CPoint2D B
    # Loop through all edges [AB] of the polygon.
    for i in range(PG.points_number - 1):
        A.x, A.y = PG.x[i], PG.y[i]
        B.x, B.y = PG.x[i+1], PG.y[i+1]

        if A.y <= P.y:
            if B.y  > P.y:
                # Upward crossing.
                if c_is_left(&A, &B, P) > 0:
                    # Have  a valid up intersect.
                    winding_number += 1
        else:
            # Downward crossing.
            if B.y  <= P.y:
                 if c_is_left(&A, &B, P) < 0: 
                     # Have  a valid down intersect.
                    winding_number -= 1
    return winding_number
