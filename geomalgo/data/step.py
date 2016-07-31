import numpy as np

"""
    12  6-------7
        | \  T5 |
        |   \   |
        | T4  \ |
    11  3-------4-------5
        | \  T2 | \  T3 |
        |   \   |   \   |
        | T0  \ | T1  \ |
    10  0-------1-------2

        0       1       2

"""

NV =  8
NT =  6

NB =  8
NI =  5
NE = 13

x = np.array([
    0, 1, 2,  # Vertices 0, 1, 2
    0, 1, 2,  # Vertices 3, 4 ,5
    0, 1,     # Vertices 6, 7
], dtype='d')

y = np.array([
    10, 10, 10,  # Vertices 0, 1, 2
    11, 11, 11,  # Vertices 3, 4 ,5
    12, 12,      # Vertices 6, 7
], dtype='d')

trivtx = np.array([
    [0, 1, 3], [1, 2, 4],  # Triangles 0 to 1
    [1, 4, 3], [2, 5, 4],  # Triangles 2 to 3
    [3, 4, 6], [4, 7, 6],  # Triangles 4 to 5
], dtype='int32')