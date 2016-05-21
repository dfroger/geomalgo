# craftr_module(geomalgo)

from craftr import path, options, Framework
from craftr.ext.compiler.cython import cythonc
from craftr.ext.platform import cxx, ld

cpp_files = cythonc.compile(
  py_sources = path.glob('geomalgo/**/*.pyx'),
  python_version = int(options.get('python_version', 3)),
  cpp = True,
)

# should be determined based on the OS
pyd_suffix = '.pyd'
python_fw = Framework(
  include = ['F:/Python34/include'],
  libpath = ['F:/Python34/libs']
)

# path to the output directory of the C/C++ files from Cython
cython_outdir = cpp_files.meta['cython_outdir']
module_dir = path.local('geomalgo')

for fn in cpp_files.outputs:
  # Transform the output filename from the C/C++ output file directory
  # to the local module directory.
  outfile = path.join(module_dir, path.relpath(fn, cython_outdir))
  outfile = path.setsuffix(outfile, pyd_suffix)

  ld.link(
    output = outfile,
    output_type = 'dll',
    keep_suffix = True,  # don't let link() replace the suffix with one appropriate for the OS (eg. dll on Windows)
    inputs = cxx.compile(
      sources = [fn],
      frameworks = [python_fw],
    ),
  )
