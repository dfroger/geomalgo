# craftr_module(geomalgo)

from craftr import path, options, error, Framework
from craftr.ext.compiler.cython import cythonc
from craftr.ext import platform, python

def cython_flags():
    
    def add_flag(name, default):
        value = options.get_bool(name, default)
        flags.append('-X {}={}'.format(name, value))

    flags = []

    add_flag('boundscheck', False)
    add_flag('cdivision', True)
    add_flag('wraparound', False)
    add_flag('initializedcheck', False)
    add_flag('profile', False)

    return flags

defines = []
if options.get_bool('profile'):
    defines.append('CYTHON_TRACE_NOGIL=1')

cython_flags()

c_files = cythonc.compile(
  py_sources = path.glob('geomalgo/**/*.pyx'),
  python_version = 3,
  cpp = False,
  additional_flags = cython_flags()
)

pybin = options.get('PYTHON', 'python')
pyd_suffix = python.get_python_config_vars(pybin)['SO']
python_fw = python.get_python_framework(pybin)

# path to the output directory of the C/C++ files from Cython
cython_outdir = c_files.meta['cython_outdir']
module_dir = path.local('geomalgo')

for fn in c_files.outputs:
  # Transform the output filename from the C/C++ output file directory
  # to the local module directory.
  outfile = path.join(module_dir, path.relpath(fn, cython_outdir))
  outfile = path.setsuffix(outfile, pyd_suffix)

  platform.ld.link(
    output = outfile,
    output_type = 'dll',
    keep_suffix = True, # don't let link() replace the suffix with one
                        # appropriate for the OS (eg. dll on Windows)
    inputs = platform.cc.compile(
      sources = [fn],
      frameworks = [python_fw],
      pic = True,
      defines = defines
    ),
  )
