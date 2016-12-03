# geomalgo

Cython implementation of http://geomalgorithms.com

[![Travis Build Status](https://travis-ci.org/dfroger/geomalgo.svg?branch=master)](https://travis-ci.org/dfroger/geomalgo)

## Development

### Install dependencies

Install Python 3.5, Cython, and nose in a Conda environment:

    $ conda create -n geomalgo python=3.5 cython numpy nose coverage matplotlib
    $ source activate geomalgo

### Install build system

1. Install [Ninja](https://ninja-build.org)
2. Install [Craftr 2.x](https://github.com/craftr-build/craftr) from Git

        $ git clone https://github.com/craftr-build/craftr && cd craftr
        $ source activate geomalgo
        $ pip install -e .

### Build & test

    # Build
    $ cd geomalgo
    $ CXX=gcc craftr export
    $ craftr build

    # Test
    $ nosetests

    # Test coverage
    $ nosetests --with-coverage --cover-package=geomalgo
    $ coverage html
