import numpy as np

"""
    6-------7
    | \  T5 |
    |   \   |
    | T4  \ |
    3-------4-------5
    | \  T2 | \  T3 |
    |   \   |   \   |
    | T0  \ | T1  \ |
    0-------1-------2

"""

trivtx = np.array([
    [0, 1, 3], [1, 2, 4], # Triangles 0 to 1
    [1, 4, 3], [2, 5, 4], # Triangles 2 to 3
    [3, 4, 6], [4, 7, 6], # Triangles 4 to 5
], dtype='int32')

