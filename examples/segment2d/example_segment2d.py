"""
=================================
Segment2D
=================================

Create a segment
"""

import matplotlib.pylab as plt

import geomalgo as ga

# Create segment AB.
A = ga.Point2D(2, 1, name='A')
B = ga.Point2D(5, 4, name='B')
AB = ga.Segment2D(A, B)

# Create two points, the first on the segment
C = ga.Point2D(3, 2, name='C')
D = ga.Point2D(4, 2, name='D')

# Plot points and segment.
A.plot()
B.plot()
AB.plot()
C.plot(color='red')
D.plot(color='red')

# Adjust the plot.
plt.axis('scaled')
plt.xlim(1, 6)
plt.ylim(0, 5)
plt.grid()
plt.show()

print('AB includes point C:', AB.includes_point(C))
print('AB includes point D:', AB.includes_point(D))
