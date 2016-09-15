"""
=================================
Point2D
=================================

Create two 2-dimensional points, and compute distance between them.
"""

import matplotlib.pylab as plt

import geomalgo as ga

# Create two points.
A = ga.Point2D(2, 1, name='A')
B = ga.Point2D(6, 4, name='B')

# Plot the points.
A.plot()
B.plot()

# Compute distance.
print("Distance : {}".format(A.distance(B)))

# Adjust the plot.
plt.axis('scaled')
plt.xlim(1, 7)
plt.ylim(0, 5)
plt.grid()
plt.show()
