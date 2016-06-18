from pathlib import Path
import os
import site
import subprocess
import platform
import distutils.sysconfig

from waflib import Logs, TaskGen

top = os.path.realpath('.')
out = os.path.realpath('./build')

class DynamicLibrary:
    def __init__(self, filepath):
        self.filepath = Path(filepath)
        self._install_name = self._read_install_name()

    @property
    def install_name(self):
        return self._install_name

    @install_name.setter
    def install_name(self, newname):
        if newname != self._install_name:
            self._change_install_name(newname)
            self._install_name = newname

    def _read_install_name(self):
        args = ['otool', '-D', str(self.filepath)]
        completed_process = subprocess.run(args, stdout=subprocess.PIPE,
                                       universal_newlines=True, check=True)
        lines = completed_process.stdout.split('\n')
        install_name = lines[1]
        return install_name

    def _change_install_name(self, newname):
        args = ['install_name_tool', '-id', newname, str(self.filepath)]
        subprocess.run(args, check=True)

def compute_src_so(build_so, root):
    """
    >>> build_so = Path('build/freshkiss3d/mesh/mesh.cpython-35m-x86_64-linux-gnu.so')
    >>> root = Path('/root')
    >>> compute_src_so(build_so, root)
    PosixPath('/root/freshkiss3d/mesh/mesh.so')
    """
    fn = remove_arch_suffix(build_so)
    src_dir = root.joinpath(*build_so.parent.parts[1:])
    return src_dir / fn
    
def remove_arch_suffix(fp):
    """
    >>> fp = Path('/root/build/freshkiss3d/mesh/mesh.cpython-35m-x86_64-linux-gnu.so')
    >>> remove_arch_suffix(fp)
    PosixPath('mesh.so')
    """
    fn = Path(fp.stem).with_suffix('.so')
    return fn

def find_so(build_dir):
    """
    >>> first = list(find_so('build'))[0]
    >>> first.parts[:2]
    ('build', 'freshkiss3d')
    >>> first.suffixes
    ['.cpython-35m-x86_64-linux-gnu', '.so']
    """
    for root, dirs, files in os.walk(str(build_dir)):
        for fn in files:
            fn = Path(fn)
            if fn.suffix == '.so':
                root = Path(root)
                fp = root / fn
                yield fp

@TaskGen.feature('pyext')
@TaskGen.after('apply_link', 'propagate_uselib_vars')
def remove_flag_stack(self):
    """Fix for https://github.com/waf-project/waf/issues/1745"""
    if platform.system() == 'Darwin':
        flags = self.env.LINKFLAGS
        libpath = distutils.sysconfig.get_config_var('LIBDIR')
        self.env.LINKFLAGS = ['-L'+libpath, '-Wl,-rpath,'+libpath]
        self.env.LINKFLAGS.extend([x for x in flags if not x.startswith('-Wl,-stack_size,')])

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

    # On Darwin, fix Conda Python library install name
    if platform.system() == 'Darwin':
        conda_env_path = Path(os.environ['CONDA_ENV_PATH'])
        fp = conda_env_path / 'lib' / 'libpython3.5m.dylib'
        if fp.exists():
            pylib = DynamicLibrary(fp)
            pylib.install_name = "@rpath/libpython3.5m.dylib"

def link_so(bld):
    # Link build/**/.so files to source dir.
    build_dir = Path('build')
    root = Path('.').absolute()
    for build_so in find_so(build_dir):
        src_so = compute_src_so(build_so, root)
        if not src_so.is_symlink():
            print("linking ", build_so.name)
            src_so.symlink_to(root / build_so)

def build(bld):
    bld.recurse('geomalgo')
    bld.add_post_fun(link_so)

def test(ctx):
    ctx.recurse('geomalgo')
