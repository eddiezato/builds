#!/bin/bash
export CC=clang CXX=clang++
rm -rf libavif
git clone --depth 1 https://github.com/AOMediaCodec/libavif.git
cd libavif/ext
printf '\n:: Build aom ::\n'
branch=($(grep -i "git clone" aom.cmd))
git clone -b ${branch[3]} --depth 1 https://aomedia.googlesource.com/aom
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
branch=($(grep -i "git clone" dav1d.cmd))
git clone -b ${branch[3]} --depth 1 https://code.videolan.org/videolan/dav1d.git
cd dav1d
mkdir build
cd build
CFLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    CXXFLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    LDFLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic' \
    meson --default-library=static --buildtype release ..
cd ..
ninja -C build
cd ..
printf '\n:: Build libyuv ::\n'
git clone --depth 1 https://chromium.googlesource.com/libyuv/libyuv
cd libyuv
cmake -B build -G Ninja -S ./ \
    -DBUILD_SHARED_LIBS=0 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build yuv
cd ../..
printf '\n:: Build libavif ::\n'
cmake -B build -G Ninja -S ./ \
    -DCMAKE_INSTALL_PREFIX=/mingw64 \
    -DCMAKE_BUILD_TYPE=Release \
    -DAVIF_CODEC_AOM=ON \
    -DAVIF_LOCAL_AOM=ON \
    -DAVIF_CODEC_DAV1D=ON \
    -DAVIF_LOCAL_DAV1D=ON \
    -DAVIF_LOCAL_LIBYUV=ON \
    -DAVIF_BUILD_APPS=ON \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build
ninja install -C build