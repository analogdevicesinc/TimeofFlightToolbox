#!/bin/bash

set -ex

# Script is designed to run from specific location
scriptdir=`dirname "$BASH_SOURCE"`
cd $scriptdir
targetdir=`pwd`
cd ..

cd /tmp/
git clone --branch v0.3.5 --depth 1 https://github.com/google/glog
cd glog
mkdir build_0_3_5 && cd build_0_3_5
cmake -DWITH_GFLAGS=off -DCMAKE_INSTALL_PREFIX=/opt/glog ..
cmake --build . --target install
ldconfig

cd /tmp/
apt-get install libssl-dev
git clone --branch v3.1-stable --depth 1 https://github.com/warmcat/libwebsockets
cd libwebsockets
mkdir build_3_1 && cd build_3_1
cmake -DLWS_STATIC_PIC=ON -DCMAKE_INSTALL_PREFIX=/opt/websockets ..
cmake --build . --target install
ldconfig

cd /tmp/
git clone --branch v3.9.0 --depth 1 https://github.com/protocolbuffers/protobuf
cd protobuf
mkdir build_3_9_0 && cd build_3_9_0
cmake -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX=/opt/protobuf ../cmake
cmake --build . --target install
ldconfig

cd /tmp/
git clone https://github.com/analogdevicesinc/aditof_sdk
cd aditof_sdk
git checkout "$TOFBRANCH"
mkdir build && cd build
cmake -DWITH_EXAMPLES=off -DWITH_MATLAB=on -DMatlab_ROOT_DIR=/usr/local/MATLAB/"$MLRELEASE" -DCMAKE_PREFIX_PATH="/opt/glog;/opt/protobuf;/opt/websockets" ..
make

# Move file
cd `dirname "$BASH_SOURCE"`
ADAPTOR="/tmp/aditof_sdk/build/bindings/matlab/aditofadapter.so"
if test -f "$ADAPTOR"; then
    mkdir "$targetdir/../../deps"
    pwd
    echo $targetdir
    cp $ADAPTOR "$targetdir/../../deps"
else
    exit 22
fi
