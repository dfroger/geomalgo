cpdef inline double symetric_1d(double center, double x):
    """
    +------+------+
    x    center   symetric
    """
    # center = (x + symetric) / 2
    # so 
    # symetric = 2*center - x
    return 2*center - x

