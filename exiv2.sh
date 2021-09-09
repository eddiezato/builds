#!/bin/bash
export CC=clang CXX=clang++
git clone https://github.com/Exiv2/exiv2.git --recursive
cd exiv2
rm -rf build
cmake -B build -G Ninja -S ./ \
    -DEXIV2_BUILD_SAMPLES=OFF \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build