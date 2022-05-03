#!/bin/bash
export CC=clang CXX=clang++
rm -rf mozjpeg
git clone --depth 1 https://github.com/mozilla/mozjpeg.git
cd mozjpeg
cmake -B build -G Ninja -S ./ \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_STATIC=ON \
    -DENABLE_SHARED=OFF \
    -Wno-dev \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections'
ninja -C build
strip -s build/*.exe
