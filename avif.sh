#!/bin/bash
export CC=clang CXX=clang++
rm -rf libavif
git clone https://github.com/AOMediaCodec/libavif.git --recursive
cd libavif
printf '\n:: Build aom ::\n'
cd ext
aomcmd=$(grep -i "git clone" aom.cmd)
eval "$aomcmd"
cd aom
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
cd ..
printf '\n:: Build dav1d ::\n'
dav1dcmd=$(grep -i "git clone" dav1d.cmd)
eval "$dav1dcmd"
cd dav1d
mkdir build
cd build
CFLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    CXXFLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    LDFLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic' \
    meson --default-library=static --buildtype release ..
cd ..
ninja -C build
cd ../..
printf '\n:: Build libavif ::\n'
cmake -B build -G Ninja -S ./ \
    -DCMAKE_INSTALL_PREFIX=/mingw64 \
    -DCMAKE_BUILD_TYPE=Release \
    -DAVIF_CODEC_AOM=ON \
    -DAVIF_LOCAL_AOM=ON \
    -DAVIF_CODEC_DAV1D=ON \
    -DAVIF_LOCAL_DAV1D=ON \
    -DAVIF_BUILD_APPS=ON \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build
ninja install -C build