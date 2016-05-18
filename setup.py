import os
from setuptools import setup, Extension

from Cython.Build import cythonize

from geomalgo import __version__

#=============================================================================
# List all extensions of all packages to build.
#=============================================================================


def list_package_extensions(package_paths, filenames):
    """Create a Extension object of all .pyx file in a package"""
    extensions = []
    for filename in filenames:
        filepath = os.path.join(*package_paths, filename)
        module = os.path.splitext(filename)[0]
        module_path = package_paths + [module,]
        ext = Extension(
            '.'.join(module_path),
            sources = [filepath, ],
        )
        extensions.append(ext)
    return extensions

# base package.
base_ext = list_package_extensions(
    package_paths = ['geomalgo', 'base'],
    filenames = ['onedim.pyx', 'point.pyx', 'point2d.pyx', 'segment.pyx',
                 'triangle.pyx', 'vector.pyx', ]
)

# intersection package.
intersection_ext = list_package_extensions(
    package_paths = ['geomalgo', 'intersection'],
    filenames = ['intersection.pyx'],
)

extensions = base_ext + intersection_ext

#=============================================================================
# Main function.
#=============================================================================

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
        'geomalgo.base',
        'geomalgo.intersection',
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
    )
)
