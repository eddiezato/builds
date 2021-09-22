#!/bin/bash
export CC=gcc CXX=g++
rm -rf qimgv
git clone --depth 1 https://github.com/easymodo/qimgv.git
cd qimgv
cmake -B build -G Ninja -S ./ \
    -DVIDEO_SUPPORT=OFF \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build