#!/bin/bash
export CC=clang CXX=clang++
#export CC=gcc CXX=g++
#git clone https://github.com/nomacs/nomacs.git --recursive
cd nomacs
git pull
git submodule update --init
rm -rf build
cmake -B build -G Ninja -S ImageLounge/ \
    -DUSE_SYSTEM_QUAZIP=OFF \
    -DENABLE_PLUGINS=OFF \
    -DENABLE_TRANSLATIONS=OFF \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build