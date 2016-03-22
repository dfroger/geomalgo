from pathlib import Path
import os
import doctest

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

def main():
    build_dir = Path('build')
    root = Path('.').absolute()
    for build_so in find_so(build_dir):
        src_so = compute_src_so(build_so, root)
        if not src_so.is_symlink():
            print("linking ", build_so.name)
            src_so.symlink_to(root / build_so)

if __name__ == '__main__':
    main()
