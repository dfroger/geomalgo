# geomalgo

Cython implementation of http://geomalgorithms.com

## Development

Install Python 3.5, Cython, and nose in a Conda environment: 

    conda create -n geomalgo python=3.5 cython nose coverage
    source activate geomalgo

Install `Ninja` build system: https://ninja-build.org

Install `Craftr` from Git repository:

    git clone https://github.com/craftr-build/craftr
    cd craftr
    source activate geomalgo
    pip install -e .

TODO: Package Ninja and Craftr with Conda.

Build:
    craftr

Test:
    nosetests

Test coverage:
    nosetests --with-coverage --cover-package=geomalgo
    coverage html
