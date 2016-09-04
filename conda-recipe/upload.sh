#!/bin/bash

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$GIT_BRANCH" == "master" ]
then
    GIT_COMMIT=$(git rev-parse HEAD)

    if [ "$(uname)" == "Darwin" ]
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
        --label=$GIT_BRANCH \
        --label=$GIT_COMMIT \
        --force \
        $CONDA_PACKAGE

else
    echo "Do not upload the Conda package on $GIT_BRANCH branch (do only on master)"
fi
