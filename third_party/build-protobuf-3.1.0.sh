#!/bin/bash

# check host system
if [ "$(uname)" = "Darwin" ]; then
    HOST_OS=MacOSX
else
    echo "Unknown OS"
    exit 1
fi

# TARGET: iPhoneOS, iPhoneSimulator, MacOSX
if [ "$1" = "" ]; then
    TARGET=$HOST_OS
else
    TARGET=$1
fi

# Options for All
PB_VERSION=3.1.0
MAKE_FLAGS="$MAKE_FLAGS -j 4"
BUILD_DIR=".cbuild"
BUILD_PROTOC=OFF

echo "$(tput setaf 2)"
echo Building Google Protobuf for $TARGET
echo "$(tput sgr0)"

RUN_DIR=$PWD

function fetch-protobuf {
    echo "$(tput setaf 2)"
    echo "##########################################"
    echo " Fetch Google Protobuf $PB_VERSION from source."
    echo "##########################################"
    echo "$(tput sgr0)"

    if [ ! -f protobuf-${PB_VERSION}.tar.gz ]; then
        curl -L https://github.com/google/protobuf/archive/v${PB_VERSION}.tar.gz --output protobuf-${PB_VERSION}.tar.gz
    fi
    if [ -d protobuf-${PB_VERSION} ]; then
        rm -rf protobuf-${PB_VERSION}
    fi
    tar -xzf protobuf-${PB_VERSION}.tar.gz
}

function build-MacOSX {
    echo "$(tput setaf 2)"
    echo "#####################"
    echo " Building protobuf for $TARGET"
    echo "#####################"
    echo "$(tput sgr0)"

    mkdir -p protobuf-$PB_VERSION/$BUILD_DIR
    rm -rf protobuf-$PB_VERSION/$BUILD_DIR/*
    cd protobuf-$PB_VERSION/$BUILD_DIR
    if [ ! -s ${TARGET}-protobuf/lib/libprotobuf.a ]; then
        cmake ../cmake -DCMAKE_INSTALL_PREFIX=../../${TARGET}-protobuf \
            -Dprotobuf_BUILD_TESTS=OFF \
            -Dprotobuf_BUILD_SHARED_LIBS=OFF \
            -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations" \
            -Dprotobuf_WITH_ZLIB=OFF
        make ${MAKE_FLAGS}
        make install
    fi
    cd ../..
    rm -f protobuf
    ln -s ${TARGET}-protobuf protobuf
}

function build-iPhoneSimulator {
    echo "$(tput setaf 2)"
    echo "#####################"
    echo " Building protobuf for $TARGET"
    echo "#####################"
    echo "$(tput sgr0)"

    if [ ! -s ${TARGET}-protobuf/lib/libprotobuf.a ]; then
        mkdir -p protobuf-$PB_VERSION/$BUILD_DIR
        rm -rf protobuf-$PB_VERSION/$BUILD_DIR/*
        cd protobuf-$PB_VERSION/$BUILD_DIR
        cmake ../cmake -DCMAKE_INSTALL_PREFIX=../../${TARGET}-protobuf\
            -DCMAKE_TOOLCHAIN_FILE="../../../iOS.cmake" \
            -DIOS_PLATFORM=SIMULATOR \
            -Dprotobuf_BUILD_TESTS=OFF \
            -Dprotobuf_BUILD_SHARED_LIBS=OFF \
            -Dprotobuf_WITH_ZLIB=OFF
        make ${MAKE_FLAGS}
        make install
        cd ../..
    fi
    cd ${TARGET}-protobuf/bin
    PROTOC=protoc
    ln -sf ../../$HOST_OS-protobuf/bin/$PROTOC $PROTOC
    cd ../..
}

function build-iPhoneOS {
    echo "$(tput setaf 2)"
    echo "#####################"
    echo " Building protobuf for $TARGET"
    echo "#####################"
    echo "$(tput sgr0)"

    if [ ! -s ${TARGET}-protobuf/lib/libprotobuf.a ]; then
        mkdir -p protobuf-$PB_VERSION/$BUILD_DIR
        rm -rf protobuf-$PB_VERSION/$BUILD_DIR/*
        cd protobuf-$PB_VERSION/$BUILD_DIR
        cmake ../cmake -DCMAKE_INSTALL_PREFIX=../../${TARGET}-protobuf\
            -DCMAKE_TOOLCHAIN_FILE="../../../iOS.cmake" \
            -DIOS_PLATFORM=OS \
            -DCMAKE_CXX_FLAGS="-fembed-bitcode -Wno-deprecated-declarations" \
            -Dprotobuf_BUILD_TESTS=OFF \
            -Dprotobuf_BUILD_SHARED_LIBS=OFF \
            -Dprotobuf_WITH_ZLIB=OFF
        make ${MAKE_FLAGS}
        make install
        cd ../..
    fi
    cd ${TARGET}-protobuf/bin
    PROTOC=protoc
    ln -sf ../../$HOST_OS-protobuf/bin/$PROTOC $PROTOC
    cd ../..
}

fetch-protobuf
if [ "$TARGET" != "MacOSX" ]; then
    PROTOC_VERSION=$(./$HOST_OS-protobuf/bin/protoc --version)
    if [ "$PROTOC_VERSION" != "libprotoc 3.1.0" ]; then
        TARGET_SAVE=$TARGET
        TARGET=$HOST_OS
        build-$TARGET
        TARGET=$TARGET_SAVE
    fi
fi
build-$TARGET
