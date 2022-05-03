#!/bin/bash
export CC=clang CXX=clang++
rm -rf exiv2
git clone --depth 1 https://github.com/Exiv2/exiv2.git
cd exiv2
cmake -B build -G Ninja -S ./ \
    -DBUILD_SHARED_LIBS=OFF \
    -DEXIV2_ENABLE_BMFF=ON \
    -DEXIV2_BUILD_SAMPLES=OFF \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -static -liconv -lexpat -lz'
ninja -C build
strip -s build/bin/exiv2.exe
