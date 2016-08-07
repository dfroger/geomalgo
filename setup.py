from pathlib import Path
from setuptools import setup, Extension

from Cython.Build import cythonize

__version__ = '0.0.5'

def module_name(fp):
    """
    Return a module name from its file path.

    >>> from pathlib import Path
    >>> filepath = Path('geomalgo', 'base2d', 'point2d.pyx')
    >>> module_name(filepath)
    geomalgo.base2d.point2d
    """
    return '.'.join([*fp.parent.parts, fp.stem])

def list_sources():
    """
    Iterates on pair (module filepath, module name).

    One pair is for example:
        (geomalgo/base2d/point2d.pyx, geomalgo.base2d.point2d)
    """
    for fp in Path('.').glob('geomalgo/**/*.pyx'):
        yield str(fp), module_name(fp)

extensions = [ Extension(modname, sources=[fp,])
               for fp, modname in list_sources() ]

setup(
    name = 'geomalgo',
    version = __version__,
    url = 'https://github.com/dfroger/geomalgo',
    description = 'Cython implementation of http://geomalgorithms.com',
    license = 'BSD',
    author = 'David Froger',
    author_email = 'david.froger@mailoo.org',
    packages = [
        'geomalgo',
        'geomalgo.base1d',
        'geomalgo.base2d',
        'geomalgo.base3d',
        'geomalgo.cylindrical',
        'geomalgo.data',
        'geomalgo.inclusion',
        'geomalgo.intersection',
        'geomalgo.polar',
        'geomalgo.triangulation',
    ],
    ext_modules = cythonize(
        extensions,
        compiler_directives = {
            'boundscheck': False,
            'cdivision': True,
            'wraparound': False,
            'initializedcheck': False,
            'language_level': 3,
        },
    ),
    requires = ['numpy'],
    tests_require = ['nose', 'coverage'],
)
