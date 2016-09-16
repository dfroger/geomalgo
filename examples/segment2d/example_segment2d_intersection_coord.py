"""
======================================
Segment2D intersection coordiantes
======================================

Create segment, and find their intersections
"""

import matplotlib.pylab as plt

import geomalgo as ga

# Create segment AB.
A = ga.Point2D(2, 2, name='A')
B = ga.Point2D(6, 2, name='B')
AB = ga.Segment2D(A, B)

# Create segment CD.
C = ga.Point2D(5, 1, name='C')
D = ga.Point2D(5, 4, name='D')
CD = ga.Segment2D(C, D)

# Plot the points and the segments.
A.plot()
B.plot()
C.plot(offset=(0.2, 0))
D.plot(offset=(0.2, 0))
AB.plot()
CD.plot()

# Compute first intersection point.
X, _, coords = AB.intersect_segment(CD, return_coords=True)
X.name = 'X'
X.plot(color='red', offset=(0.2, 0.2))

print('Intersection point is on AB at parametric coordinate: {}'
      .format(coords[0]))

print('Intersection point is on CD at parametric coordinate: {}'
      .format(coords[1]))

# Adjust the plot.
plt.axis('scaled')
plt.xlim(1, 7)
plt.ylim(0, 5)
plt.grid()
plt.show()
