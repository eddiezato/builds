#!/bin/bash
export CC=clang CXX=clang++
rm -rf exiv2
git clone --depth 1 https://github.com/Exiv2/exiv2.git
cd exiv2
cmake -B build -G Ninja -S ./ \
    -DCMAKE_INSTALL_PREFIX=/mingw64 \
    -DEXIV2_ENABLE_WIN_UNICODE=ON \
    -DEXIV2_ENABLE_BMFF=ON \
    -DEXIV2_BUILD_SAMPLES=OFF \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build
ninja install -C build