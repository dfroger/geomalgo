#!/bin/bash

if [ "$TRAVIS_BRANCH" == "master" ]
then
    TRAVIS_COMMIT=$(git rev-parse HEAD)

    if [ $TRAVIS_OS_NAME == "osx" ]
    then
				CONDA_PACKAGE=$(ls /Users/travis/miniconda/conda-bld/osx-64/geomalgo-*.tar.bz2)
		else
				CONDA_PACKAGE=$(ls /home/travis/miniconda/conda-bld/linux-64/geomalgo-*.tar.bz2)
		fi

    anaconda \
        --token "$ANACONDA_TOKEN" \
        upload \
        --user="$ANACONDA_USER" \
        --label=travis \
        --label=$TRAVIS_BRANCH \
        --label=$TRAVIS_COMMIT \
        --force \
        $CONDA_PACKAGE

else
    echo "Do not upload the Conda package on $TRAVIS_BRANCH branch (do only on master)"
fi
