"""
=================================
Segment2D
=================================

Create a segment
"""

import matplotlib.pylab as plt

import geomalgo as ga

# Create segment XY.
X = ga.Point2D(2, 1, name='X')
Y = ga.Point2D(5, 4, name='Y')
XY = ga.Segment2D(X, Y)

# Plot segment.
X.plot()
Y.plot()
XY.plot()

# Retrieve points.
print('Segment first point:', XY.A)
print('Segment second point:', XY.B)

# Use parametric coordinates.
print('Point at paraemtric coordinate 1/3:', XY.at(1/3))
print('Point (3, 2) is at paraemtric coordinate:', XY.where(ga.Point2D(3, 2)))

# Length and recompute.
print("Segment length:", XY.length)
XY.A.x = 4
XY.B.x = 4
print("Old egment length:", XY.length)
XY.recompute()
print("Updated segment length:", XY.length)

# Adjust the plot.
plt.axis('scaled')
plt.xlim(1, 6)
plt.ylim(0, 5)
plt.grid()
plt.show()
