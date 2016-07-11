# geomalgo

Cython implementation of http://geomalgorithms.com

[![Travis Build Status](https://travis-ci.org/dfroger/geomalgo.svg?branch=master)](https://travis-ci.org/dfroger/geomalgo)


## Development

### Install dependencies

Install Python 3.5, Cython, and nose in a Conda environment:

    conda create -n geomalgo python=3.5 cython numpy nose coverage
    source activate geomalgo

### Install build system

Install `Ninja` build system: https://ninja-build.org

Install `Craftr` from Git repository:

    git clone https://github.com/craftr-build/craftr
    cd craftr
    source activate geomalgo
    pip install -e .

### Build

Build:

    craftr

Test:

    nosetests

Test coverage:

    nosetests --with-coverage --cover-package=geomalgo
    coverage html
