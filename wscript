from pathlib import Path
import os
import site
from waflib import Logs

top = os.path.realpath('.')
out = os.path.realpath('./build')

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
