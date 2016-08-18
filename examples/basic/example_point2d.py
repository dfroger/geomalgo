"""
=================================
Point2D class
=================================

Create two 2-dimensional points, and compute distance between them.
"""

import matplotlib.pylab as plt

import geomalgo as ga

# Create two points.
A = ga.Point2D(2, 1)
B = ga.Point2D(6, 4)

# Compute distance.
dist = A.distance(B)
print("Distance between A and B is: {}".format(dist))

# Plot the points.
plt.plot([A.x, B.x], [A.y, B.y], 'bo-')
plt.text(A.x, A.y+0.2, 'A', horizontalalignment='center')
plt.text(B.x, B.y+0.2, 'B', horizontalalignment='center')

# Adjust the plot.
plt.axis('scaled')
plt.xlim(1, 7)
plt.ylim(0, 5)
plt.grid()
plt.show()
