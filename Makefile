.PHONY: default configure build clean distclean test cover

default: build

# ======================== Dependencies installation =========================
CONDA_PKGS = python=3.5 cython numpy nose coverage matplotlib sphinx-gallery craftr

# Set up conda environment with geomalgo dependencies.
env:
	conda env create -f environment.yml

# Create environment.yml file again.
update-env:
	conda remove --yes --all -n geomalgo-dev
	conda create --yes -n geomalgo-dev -c conda-forge -c dfroger $(CONDA_PKGS)
	conda env export -n geomalgo-dev > environment.yml

# ============================ configure & build =============================
configure:
	CXX=gcc craftr export

build:
	craftr build

# ================================== clean ===================================
clean:
	@if [ -d "build/" ]; then ninja -C build/ -t clean; fi
	rm -rf ~/.cache/ipython/cython

distclean: clean
	@rm -rf build/

rebuild: distclean configure build

# ================================== tests ===================================
test:
	nosetests

cover:
	nosetests --with-coverage --cover-package=geomalgo
	coverage html

# ================================ notebooks =================================

nb:
	PYTHONPATH=$(PWD) CFLAGS='-Wno-unused-function -Wno-unused-variable' jupyter notebook --NotebookApp.token= --browser=firefox
