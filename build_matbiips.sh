#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage:   ./build_matbiips.sh [-jN [-g [-oct]]]"
    echo "    Where N=nb of parallel jobs."
    echo "    The options order matters."
    echo "    Use any string that does not match the option, e.g. '-', to skip an option"
fi

set -x;
# Change these variables to fit your needs
#-----------------------------------------
# prefer absolute over relative paths
	
export MATBIIPS_SRC=`pwd`
export CMAKE_BUILD_TYPE=Release
export CMAKE_GENERATOR="Unix Makefiles"
export MAKE="make $1"

if [[ "$3" == "-oct" ]]; then
	export MATBIIPS_NAME=octbiips
	export CMAKE_OPTIONS="-DFIND_OCTAVE=ON"
else
	export MATBIIPS_NAME=matbiips
fi

if [[ "$2" == "-g" ]]; then
    export MATBIIPS_NAME=$MATBIIPS_NAME-debug
    export CMAKE_BUILD_TYPE=Debug
	# export MATLAB_ROOT=/usr/local/MATLAB/R2010b
else
    export MATBIIPS_NAME=$MATBIIPS_NAME-build
fi

if [[ "$(uname)" == "Darwin" ]]; then
    # environment variables for OS X
    export MATBIIPS_BUILD=$HOME/workspace/$MATBIIPS_NAME
    export BOOST_ROOT=$HOME/boost_1_53_0
    export MATLAB_ROOT=/Applications/MATLAB_R2016a.app
    export OCTAVE_ROOT=/opt/local
else
    # environment variables for Linux
    export MATBIIPS_BUILD=/media/data/workspace/$MATBIIPS_NAME
    export MATLAB_ROOT=/usr/local/MATLAB/R2016a
fi


#-----------------------------------------

set +x; echo -n "*** Git pull? (y/N) "; read ans
if [[ $ans == "y" ]]; then set -x
    cd $MATBIIPS_SRC
    git pull
fi

set +x; echo -n "*** Run CMake? (y/N) "; read ans
if [[ $ans == "y" ]]; then
	echo -n "*** Clear build directory? (y/N) "; read ans
	if [[ $ans == "y" ]]; then set -x
	    rm -rf $MATBIIPS_BUILD
	fi
	set +x; if [ ! -d "$MATBIIPS_BUILD" ]; then set -x
	    mkdir $MATBIIPS_BUILD
	fi
    set -x
    cd $MATBIIPS_BUILD
    cmake -G"$CMAKE_GENERATOR" $CMAKE_OPTIONS -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$MATBIIPS_ROOT $MATBIIPS_SRC
fi


set +x; echo -n "*** Build matbiips? (y/N) "; read ans
if [[ $ans == "y" ]]; then set -x
    cd $MATBIIPS_BUILD
    $MAKE matbiips_package

    set +x; echo -n "*** Run matbiips tests? (y/N) "; read ans
    if [[ $ans == "y" ]]; then set -x
    cd $MATBIIPS_BUILD
        ctest -VV
    fi
fi


set +x; read -p "*** Press [Enter] key to finish..."

