"""
=================================
Triangle2D
=================================

Create a triangle
"""

import math

import numpy as np
import matplotlib.pylab as plt

import geomalgo as ga

# Create segment XY.
X = ga.Point2D(2, 1, name='X')
Y = ga.Point2D(5, 4, name='Y')
Z = ga.Point2D(5, 1, name='Z')
XYZ = ga.Triangle2D(X, Y, Z)

# Plot triangle.
X.plot()
Y.plot()
Z.plot(offset=(0.2, 0))
XYZ.plot()

# Retrive points.
print('First triangle point: ', XYZ.A)
print('Second triangle point: ', XYZ.B)
print('Third triangle point: ', XYZ.C)

# Retrive various information.
print('Triangle area: ', XYZ.area)
print('Triangle center: ', XYZ.center)
print('Triangle is counterclockwise: ', XYZ.counterclockwise)

# Test point inclusion
P = ga.Point2D(4, 4)
print('Triangle includes point (4,4):', XYZ.includes_point(P))
P.y = 2
print('Triangle includes point (4,2):', XYZ.includes_point(P))

# Interpolation
def f(x, y):
    return 3*x + y - 1

x = np.array([X.x, Y.x, Z.x])
y = np.array([X.y, Y.y, Z.y])

data = f(x, y)

actual = XYZ.interpolate(data, P)
expected = f(P.x, P.y)

print('data interpolated on P: {} (expected: {})'.format(actual, expected))

# In any triangle point coordinate change, .recompute() muse be called.
X.x = 3
Y.y = 3
print('Old area:', XYZ.area)
XYZ.recompute()
print('New area:', XYZ.area)

# Adjust the plot.
plt.axis('scaled')
plt.xlim(1, 6)
plt.ylim(0, 5)
plt.grid()
plt.show()
