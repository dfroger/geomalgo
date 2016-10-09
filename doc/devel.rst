=================
Developer's Guide
=================

Documentation
-------------

.. code-block:: bash

    conda install sphinx pillow matplotlib
    conda install -n fk -c menpo mayavi
    pip install sphinx-gallery sphinxcontrib-napoleon

Release
-------

Update CHANGELOG file.

Bump version number in files:

- conda-recipe/meta.yaml
- setup.py
- geomalgo/__init__.py

Commit and tag:
    git commit -m 'Bump to verions X.Y.Z'
    git tag X.Y.Z
    git push --tags
