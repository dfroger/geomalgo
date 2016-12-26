from ..base2d cimport CPoint2D

cdef class Grid2D:
    cdef public:
        double xmin
        double xmax
        int nx

        double ymin
        double ymax
        int ny

        double dx
        double dy

    cdef void c_find_cell(Grid2D self, Cell2D cell, CPoint2D* P)


cdef class Cell2D:
    cdef public:
        int index

        int ix
        int iy

        double xmin
        double xmax

        double ymin
        double ymax
