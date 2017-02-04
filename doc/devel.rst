=================
Developer's Guide
=================

Build
-----

.. code-block:: bash

   conda install python=3.5 cython craftr

Test
----

.. code-block:: bash

   conda install nose

Documentation
-------------

.. code-block:: bash

    conda install matplotlib jupyter nbsphinx sphinx_rtd_theme sphinx-gallery
    pip install wurlitzer

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

Change version number to X.Y.<Z+1>dev in files:

- conda-recipe/meta.yaml
- setup.py
- geomalgo/__init__.py

.. warning::

    Changing version number to X.Y.<Z+1>dev is important, because on each commit,
    conda packages are built on Travis, and uploaded to anaconda.org.

    If version number remains to X.Y.Z, development package will erase tagged
    package on anaconda.org
