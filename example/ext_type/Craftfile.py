# craftr_module(typed)

from craftr import *
from craftr.ext.compiler import cython

cython.cythonc.compile_project(
  sources = path.glob('*.pyx'),
  cpp = False,
)

