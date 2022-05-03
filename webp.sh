#!/bin/bash
export CC=clang CXX=clang++
rm -rf libwebp
git clone --depth 1 https://chromium.googlesource.com/webm/libwebp
cd libwebp
cmake -B build -G Ninja -S ./ \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections'
ninja -C build
strip -s build/*.exe
