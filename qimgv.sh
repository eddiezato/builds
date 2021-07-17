#!/bin/bash
export CC=gcc CXX=g++
#git clone https://github.com/easymodo/qimgv.git
cd qimgv
git pull
rm -rf build
cmake -B build -G Ninja -S ./ \
    -DVIDEO_SUPPORT=OFF \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build