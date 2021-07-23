#!/bin/bash
export CC=clang CXX=clang++
git clone https://github.com/xiph/flac.git --recursive
cd flac
git pull
rm -rf build
cmake -B build -G Ninja -S ./ \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_OGG=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_DOCS=OFF \
    -DINSTALL_MANPAGES=OFF \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic -fstack-protector-strong -static'
ninja -C build