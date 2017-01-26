import numpy as np

from .util import compute_interpolator

cdef class TriangulationInterpolator:

    def __init__(TriangulationInterpolator self,
                 Triangulation2D TG,
                 TriangulationLocator locator, int NP,
                 double[:,:] gradx=None, double[:,:] grady=None,
                 double[:,:] det=None):

        if None in (gradx, grady, det):
            self.gradx, self.grady, self.det = compute_interpolator(TG)
        else:
            self.gradx = gradx
            self.grady = grady
            self.det   = det

        self.locator = locator
        self.TG = TG
        self.NP = NP

        self.triangles = np.empty(NP, dtype='int32')
        self.factors = np.empty( (NP, 3), dtype='d')

    cpdef int set_points(TriangulationInterpolator self,
                         double[:] xpoints, double[:] ypoints):
        """
        Find triangle containing (x,y) and precompute interpolation factors

        """

        cdef:
            int P, T
            int nout # Number of points out of the domain
            double x, y
            # Shorter names
            double[:,:] gradx = self.gradx
            double[:,:] grady = self.grady
            double[:,:] det   = self.det

        assert xpoints.shape[0] == self.NP
        assert ypoints.shape[0] == self.NP
        assert self.triangles.shape[0] == self.NP

        nout = self.locator.search_points(xpoints, ypoints, self.triangles)

        # Loop on all points we want to interpolate on.
        for P in range(self.NP):
            T = self.triangles[P]
            if T == -1:
                continue

            x = xpoints[P]
            y = ypoints[P]

            # Compute interpolation factors.
            self.factors[P,0] = det[T,0] + x*gradx[T,0] + y*grady[T,0]
            self.factors[P,1] = det[T,1] + x*gradx[T,1] + y*grady[T,1]
            self.factors[P,2] = det[T,2] + x*gradx[T,2] + y*grady[T,2]

        return nout

    cpdef void interpolate(TriangulationInterpolator self, double[:] vertdata,
                          double[:] pointdata):
        """ data are the values defined on all mesh vertices. """

        cdef:
            int V0,V1,V2, T,P

        assert vertdata.shape[0] == self.TG.NV
        assert pointdata.shape[0] == self.NP

        for P in range(self.NP):
            T = self.triangles[P]
            if T == -1:
                continue
            V0 = self.TG.trivtx[T,0]
            V1 = self.TG.trivtx[T,1]
            V2 = self.TG.trivtx[T,2]

            pointdata[P] = vertdata[V0] * self.factors[P,0] + \
                           vertdata[V1] * self.factors[P,1] + \
                           vertdata[V2] * self.factors[P,2]
