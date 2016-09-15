"""
=================================
Segment2D intersection
=================================

Create segment, and find their intersections
"""

import matplotlib.pylab as plt

import geomalgo as ga

# Create two points.
A = ga.Point2D(2, 1, name='A')
B = ga.Point2D(6, 4, name='B')
AB = ga.Segment2D(A, B)

C = ga.Point2D(5, 2, name='C')
D = ga.Point2D(3, 3, name='D')
CD = ga.Segment2D(C, D)

# Plot the points and the segments.
for p in [A, B, C, D]:
    p.plot()
AB.plot()
CD.plot()

# Compute intersection
I, _ = AB.intersect_segment(CD)
I.name = 'I'
I.plot(color='red')

# Adjust the plot.
plt.axis('scaled')
plt.xlim(1, 7)
plt.ylim(0, 5)
plt.grid()
plt.show()
