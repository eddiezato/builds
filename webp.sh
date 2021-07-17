#!/bin/bash
export CC=clang CXX=clang++
#git clone https://chromium.googlesource.com/webm/libwebp --recursive
cd libwebp
git pull
rm -rf build
cmake -B build -G Ninja -S ./ \
    -DCMAKE_INSTALL_PREFIX=/mingw64 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build
ninja install -C build