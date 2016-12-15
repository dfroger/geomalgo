# geomalgo

Cython implementation of http://geomalgorithms.com

[![Travis Build Status](https://travis-ci.org/dfroger/geomalgo.svg?branch=master)](https://travis-ci.org/dfroger/geomalgo)

## Development

### Install dependencies

Install the conda package manager, and set up the `geomalgo` conda environment
with:

    make env

### Build & test

Activate the geomalgo environment:

    source activate geomalgo-dev

Configure and build:

    make configure
    make

Test:

    make test
    make cover

Clean:

    make clean     # Clean build
    make distclean # Clean build and configure
