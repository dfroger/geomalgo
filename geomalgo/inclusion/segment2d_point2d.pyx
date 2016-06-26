cdef bint segment2d_includes_point2d(CSegment2D* S, CPoint2D* P):
    """
    Determine if a point is inside a segment

    Parameters
    ----------

    P: Point2D
       A point.

    S: Segment2d
        A collinar segment.

    Returns
    -------

    bint
        True if P is inside S, False if P is not inside S
    """
    if S.A.x != S.B.x:
        # S is not  vertical.
        if S.A.x <= P.x <= S.B.x:
            return True
        if S.A.x >= P.x >= S.B.x:
            return True

    else:
        # S is vertical, so test y coordinate.
        if S.A.y <= P.y <= S.B.y:
            return True
        if S.A.y >= P.y >= S.B.y:
            return True

    return False

