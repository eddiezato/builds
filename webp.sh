#!/bin/bash
export CC=clang CXX=clang++
rm -rf libwebp
git clone https://chromium.googlesource.com/webm/libwebp --recursive
cd libwebp
cmake -B build -G Ninja -S ./ \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build