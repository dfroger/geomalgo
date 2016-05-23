from pathlib import Path
import os
import site
from waflib import Logs

top = os.path.realpath('.')
out = os.path.realpath('./build')

import distutils.sysconfig
import platform
from waflib import TaskGen
@TaskGen.feature('pyext')
@TaskGen.after('apply_link', 'propagate_uselib_vars')
def remove_flag_stack(self):
    """Fix for https://github.com/waf-project/waf/issues/1745"""
    if platform.system() == 'Darwin':
        flags = self.env.LINKFLAGS
        self.env.LINKFLAGS = [x for x in flags if not x.startswith('-Wl,-stack_size,')]
        libpath = distutils.sysconfig.get_config_var('LIBDIR')
        self.env.LINKFLAGS.insert(0, '-L'+libpath)

def options(opt):
    opt.load('use_config')
    opt.load('compiler_c')
    opt.load('python')
    opt.load('cython')
    opt.add_option('--install-python-path', action='store_true', default=False,
        help='Install geomalgo.pth for development mode.')

def configure(conf):
    # User config
    if not conf.options.use_config:
        conf.options.use_config = 'release'
    from waflib.extras import use_config
    use_config.DEFAULT_DIR = 'config'
    conf.load('use_config')

    conf.load('compiler_c')
    conf.load('python')
    conf.check_python_headers()
    conf.load('cython')

    # Install geomalgo.pth file.
    if conf.options.install_python_path:
        python_dir = Path( site.getsitepackages()[0] )
        fkpth = python_dir / "geomalgo.pth"
        with fkpth.open('w') as f:
            f.write(top + '\n')
        Logs.info('write file ' + str(fkpth))

def build(bld):
    bld.recurse('geomalgo')

def test(ctx):
    ctx.recurse('geomalgo')
