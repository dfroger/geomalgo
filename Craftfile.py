# craftr_module(geomalgo)

from craftr import *
from craftr.ext.compiler import cython

def cython_flags():    
    flags = []
    def add_flag(name, default):
        value = options.get_bool(name, default)
        flags.append('-X {}={}'.format(name, value))

    add_flag('boundscheck', False)
    add_flag('cdivision', True)
    add_flag('wraparound', False)
    add_flag('initializedcheck', False)
    add_flag('profile', False)
    return flags

def cython_defines():
    defines = []
    if options.get_bool('profile'):
        defines.append('CYTHON_TRACE_NOGIL=1')
    return defines

cython.cythonc.compile_project(
  sources = path.glob('geomalgo/**/*.pyx'),
  python_bin = options.get('PYTHON', 'python'),
  cpp = False,
  additional_flags = cython_flags(),
  defines = cython_defines()
)

