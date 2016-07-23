import unittest

from geomalgo import Triangulation2D
from geomalgo.data import triangulation as example_data

class TestTriangulation(unittest.TestCase):

    def test_normal(self):

        triangulation = Triangulation2D(example_data.x, example_data.y,
                                        example_data.trivtx)

if __name__ == '__main__':
    unittest.main()
