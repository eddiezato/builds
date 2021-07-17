#!/bin/bash
export CC=clang CXX=clang++
#git clone https://github.com/AOMediaCodec/libavif.git --recursive
cd libavif
git pull
cd ext
rm -rf aom
./aom.cmd
cd ..
rm -rf build
cmake -B build -G Ninja -S ./ \
    -DCMAKE_INSTALL_PREFIX=/mingw64 \
    -DCMAKE_BUILD_TYPE=Release \
    -DAVIF_CODEC_AOM=ON \
    -DAVIF_LOCAL_AOM=ON \
    -DAVIF_BUILD_APPS=ON \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build
ninja install -C build