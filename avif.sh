#!/bin/bash
export CC=clang CXX=clang++
rm -rf libavif
git clone https://github.com/AOMediaCodec/libavif.git --recursive
cd libavif/ext
aomcmd=$(grep -i "git clone" aom.cmd)
eval "$aomcmd"
cd aom
mkdir build.libavif
cmake -B build.libavif -G Ninja -S ./ \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_DOCS=0 \
    -DENABLE_EXAMPLES=0 \
    -DENABLE_TESTDATA=0 \
    -DENABLE_TESTS=0 \
    -DENABLE_TOOLS=0 \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build.libavif
cd ../..
rm -rf build
cmake -B build -G Ninja -S ./ \
    -DCMAKE_INSTALL_PREFIX=/mingw64 \
    -DCMAKE_BUILD_TYPE=Release \
    -DAVIF_CODEC_AOM=ON \
    -DAVIF_LOCAL_AOM=ON \
    -DAVIF_BUILD_APPS=ON \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build
ninja install -C build