from ..base2d cimport Triangle2D, Point2D

cdef class Triangulation2D:


    def __init__(self, double[:] x, double[:] y, int[:,:] trivtx):
        self.x = x
        self.y = y
        self.trivtx = trivtx


    cdef c_get(Triangulation2D self, int triangle_index, CTriangle2D* triangle):
        """
        Set 2D triangle point coordinates from its index in a triangulation

        Notes:
        ------

        Triangle points must be allocated before calling this function.
        """
        cdef:
            # Get points A, B and C indexes.
            int IA = self.trivtx[triangle_index, 0]
            int IB = self.trivtx[triangle_index, 1]
            int IC = self.trivtx[triangle_index, 2]

        # Set triangle point A coordinates
        triangle.A.x = self.x[IA]
        triangle.A.y = self.y[IA]

        # Set triangle point B coordinates
        triangle.B.x = self.x[IB]
        triangle.B.y = self.y[IB]

        # Set triangle point C coordinates
        triangle.C.x = self.x[IC]
        triangle.C.y = self.y[IC]


    def __getitem__(Triangulation2D self, int triangle_index):
        cdef:
            Triangle2D triangle = Triangle2D.__new__(Triangle2D)

        triangle.alloc_new()

        self.c_get(triangle_index, &triangle.ctri2d)
        triangle.index = triangle_index
        triangle.recompute()
        return triangle
