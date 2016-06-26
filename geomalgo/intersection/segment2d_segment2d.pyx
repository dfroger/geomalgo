from ..base2d.point2d cimport (subtract_points2d, point2d_plus_vector2d,
                               point2d_equal)
from ..base2d.vector2d cimport CVector2D, cross_product2d, dot_product2d
from ..inclusion.segment2d_point2d cimport segment2d_includes_point2d

cdef int intersect_segment2d_segment2d(CSegment2D* segment0,
                                       CSegment2D* segment1,
                                       CPoint2D* I0, CPoint2D* I1,
                                       double epsilon=1.E-08):
    """
    Find the 2D intersection of 2 finite segments

    http://geomalgorithms.com/a05-_intersect-1.html

    Input:  two finite segments segment0 and segment1
    Output: *I0 = intersect point (when it exists)
            *I1 =  endpoint of intersect segment [I0,I1] (when it exists)
    Return: 0=disjoint (no intersect)
            1=intersect  in unique point I0
            2=overlap  in segment from I0 to I1

           S
           |
           |
           |
        P--I-------Q
           |
           R
    """
    cdef:
        # Extract points.
        CPoint2D* P = segment0.A
        CPoint2D* Q = segment0.B
        CPoint2D* R = segment1.A
        CPoint2D* S = segment1.B

        CVector2D PQ, RS, RP, RQ
        double D, PQ2, RS2, t0, t1, sI, tI

    subtract_points2d(&PQ, Q, P)
    subtract_points2d(&RS, S, R)
    subtract_points2d(&RP, P, R)
    D = cross_product2d(&PQ, &RS)

    # Test if they are parallel (includes either being a point)
    # segment0 and segment1 are parallel
    if abs(D) < epsilon:
        if cross_product2d(&PQ,&RP) != 0 or cross_product2d(&RS,&RP) != 0:
            ## They are NOT collinear.
            return 0

        # they are collinear or degenerate
        # check if they are degenerate  points
        PQ2 = dot_product2d(&PQ,&PQ)
        RS2 = dot_product2d(&RS,&RS)

        if PQ2==0 and RS2==0:
            # Both segments are points.
            if not point2d_equal(P, R):
                # They are distinct points
                return 0
            # they are the same point
            I0 = P
            return 1

        if PQ2 == 0:
            # segment0 is a single point
            if not segment2d_includes_point2d(segment1, P):
                # But is not in segment1.
                return 0
            I0 = P
            return 1

        if RS2 == 0:
            # segment1 a single point
            if  not segment2d_includes_point2d(segment0, R):
                # But is not in segment0.
                return 0
            I0 = R
            return 1

        # They are collinear segments - get  overlap (or not).
        # Endpoints of segment0 in eqn for segment1.
        subtract_points2d(&RQ, Q, R)
        if RS.x != 0:
             t0 = RP.x / RS.x
             t1 = RQ.x / RS.x
        else:
             t0 = RP.y / RS.y
             t1 = RQ.y / RS.y

        # Must have t0 smaller than t1
        if t0 > t1:
             # Swap if not.
             t0, t1 = t1, t0

        if t0 > 1 or t1 < 0:
            # No overlap
            return 0

        t0 = max(0, t0)
        t1 = min(t1, 1)

        if t0 == t1:
            # Intersect is a point.
            point2d_plus_vector2d(I0, R, t0, &RS)

        # They overlap in a valid subsegment.
        point2d_plus_vector2d(I0, R, t0, &RS)
        point2d_plus_vector2d(I1, R, t1, &RS)
        return 2

    # The segments are skew and may intersect in a point.
    # Get the intersect parameter for segment0.
    sI = cross_product2d(&RS, &RP) / D
    if sI < 0 or sI > 1:
        # No intersect with segment0.
        return 0

    # Get the intersect parameter for segment1.
    tI = cross_product2d(&PQ, &RP) / D
    if tI < 0 or tI > 1:
        # No intersect with segment1.
        return 0

    # Compute segment0 intersect point
    point2d_plus_vector2d(I0, P, sI, &PQ)
    return 1
