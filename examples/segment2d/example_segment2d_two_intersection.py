"""
=================================
Segment2D two intersection
=================================

Create segment, and find their intersections
"""

import matplotlib.pylab as plt

import geomalgo as ga

# Create segment AB.
A = ga.Point2D(2, 1, name='A')
B = ga.Point2D(6, 3, name='B')
AB = ga.Segment2D(A, B)

# Create segment CD.
C = ga.Point2D(4, 2, name='C')
D = ga.Point2D(8, 4, name='D')
CD = ga.Segment2D(C, D)

# Plot the points and the segments.
for p in [A, B, C, D]:
    p.plot()
AB.plot()
CD.plot()

# Compute intersection
I, J = AB.intersect_segment(CD)

# Plot first intersection Point.
I.name = 'I'
I.plot(marker='x', markersize=12, color='red', offset=(0, -0.4))

# Plot second intersection Point.
J.name = 'J'
J.plot(marker='x', markersize=12, color='red', offset=(0, -0.4))

# Adjust the plot.
plt.axis('scaled')
plt.xlim(1, 9)
plt.ylim(0, 5)
plt.grid()
plt.show()
