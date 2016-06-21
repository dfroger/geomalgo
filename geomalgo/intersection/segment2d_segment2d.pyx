from ..base2d.point2d cimport subtract_points2d, point2d_plus_vector2d
from ..base2d.vector2d cimport CVector2D, cross_product2d, dot_product2d
from ..inclusion.segment2d_point2d cimport segment2d_includes_point2d

cdef int intersect_segment2d_segment2d(CSegment2D* S1, CSegment2D* S2, 
                                       CPoint2D* I0, CPoint2D* I1,
                                       double epsilon=1.E-08):
    """
    Find the 2D intersection of 2 finite segments

    http://geomalgorithms.com/a05-_intersect-1.html

   Input:  two finite segments S1 and S2
   Output: *I0 = intersect point (when it exists)
           *I1 =  endpoint of intersect segment [I0,I1] (when it exists)
   Return: 0=disjoint (no intersect)
           1=intersect  in unique point I0
           2=overlap  in segment from I0 to I1
    """
    cdef:
        CVector2D u, v, w, w2
        double D, du, dv, t0, t1, sI, tI

    subtract_points2d(&u, S1.B, S1.A)
    subtract_points2d(&v, S2.B, S2.A)
    subtract_points2d(&w, S1.A, S2.A)
    D = cross_product2d(&u, &v)

    # Test if they are parallel (includes either being a point)
    # S1 and S2 are parallel
    if abs(D) < epsilon:
        if cross_product2d(&u,&w) != 0 or cross_product2d(&v,&w) != 0:
            ## They are NOT collinear.
            return 0

        # they are collinear or degenerate
        # check if they are degenerate  points
        du = dot_product2d(&u,&u)
        dv = dot_product2d(&v,&v)

        if du==0 and dv==0:             
            # Both segments are points.
            if S1.A !=  S2.A:        
                # They are distinct points
                return 0
            # they are the same point
            I0 = S1.A            
            return 1

        if du == 0: 
            # S1 is a single point
            if segment2d_includes_point2d(S2, S1.A) == 0:
                # But is not in S2.
                return 0
            I0 = S1.A
            return 1

        if dv == 0:
            # S2 a single point
            if  segment2d_includes_point2d(S1, S2.A) == 0:
                # But is not in S1.
                return 0
            I0 = S2.A
            return 1

        # They are collinear segments - get  overlap (or not).
        # Endpoints of S1 in eqn for S2.
        subtract_points2d(&w2, S1.B, S2.A)
        if v.x != 0:
             t0 = w.x / v.x
             t1 = w2.x / v.x
        else:
             t0 = w.y / v.y
             t1 = w2.y / v.y

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
            point2d_plus_vector2d(I0, S2.A, t0, &v)

        # They overlap in a valid subsegment.
        point2d_plus_vector2d(I0, S2.A, t0, &v)
        point2d_plus_vector2d(I1, S2.A, t1, &v)
        return 2

    # The segments are skew and may intersect in a point.
    # Get the intersect parameter for S1.
    sI = cross_product2d(&v, &w) / D
    if sI < 0 or sI > 1:
        # No intersect with S1.
        return 0

    # Get the intersect parameter for S2.
    tI = cross_product2d(&u, &w) / D
    if tI < 0 or tI > 1:
        # No intersect with S2.
        return 0

    # Compute S1 intersect point
    point2d_plus_vector2d(I0, S1.A, sI, &u)
    return 1
