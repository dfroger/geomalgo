.PHONY: default configure build clean distclean test cover

default: build

configure:
	CXX=gcc craftr export

build:
	craftr build

clean:
	@if [ -d "build/" ]; then ninja -C build/ -t clean; fi

distclean: clean
	@rm -rf build/

test:
	nosetests

cover:
	nosetests --with-coverage --cover-package=geomalgo
	coverage html
