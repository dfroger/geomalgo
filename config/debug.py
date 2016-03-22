def configure(conf):
    conf.options.install_python_path = True
    conf.options.cython_flags = "-X " + ','.join([
        'boundscheck=True',
        'cdivision=False',
        'wraparound=False',
        'initializedcheck=True',
        'language_level=3',
    ])
