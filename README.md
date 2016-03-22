# geomalgo

Cython implementation of http://geomalgorithms.com

## Development

Install dependencies: 

    conda create -n geomalgo python=3.5 cython
    conda install -n geomalgo -c inria-pro-sed waf
    source activate geomalgo

Configure, build and test:
   waf configure
   waf build # or just: waf
   python linkso.py # one-time step. will be integrated in wscript latter.
   waf test
