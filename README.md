# geomalgo

Cython implementation of http://geomalgorithms.com

[![Travis Build Status](https://travis-ci.org/dfroger/geomalgo.svg?branch=master)](https://travis-ci.org/dfroger/geomalgo)

## Development

### Install dependencies

Install Python 3.5, Cython, and nose in a Conda environment:

    $ conda create -n geomalgo python=3.5 cython numpy nose coverage matplotlib
    $ source activate geomalgo

### Install build system

    $ conda install -n geomalgo -c conda-forge -c dfroger craftr

### Build & test

    # Build
    $ make configure
    $ make

    # Test
    $ make test
    $ make cover # test coverage

    # Clean
    make clean     # Clean build
    make distclean # Clean build and configure
