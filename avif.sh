#!/bin/bash
export CC=clang CXX=clang++
CFLG='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe'
LFLG='-Wl,--gc-sections'

rm -rf libavif
git clone --depth 1 --branch v0.10.1 https://github.com/AOMediaCodec/libavif.git
cd libavif/ext
./zlibpng.cmd
./libjpeg.cmd

printf '\n:: Build aom ::\n'
branch=($(grep -i "git clone" aom.cmd))
git clone -b ${branch[3]} --depth 1 https://aomedia.googlesource.com/aom
cd aom
cmake -B build.libavif -G Ninja -S ./ \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_DOCS=OFF \
    -DENABLE_EXAMPLES=OFF \
    -DENABLE_TESTDATA=OFF \
    -DENABLE_TESTS=OFF \
    -DENABLE_TOOLS=OFF \
    -DCMAKE_C_FLAGS="$CFLG" -DCMAKE_CXX_FLAGS="$CFLG" -DCMAKE_EXE_LINKER_FLAGS="$LFLG"
ninja -C build.libavif
cd ..

printf '\n:: Build libyuv ::\n'
branch=($(grep -i "git checkout" libyuv.cmd))
git clone --single-branch https://chromium.googlesource.com/libyuv/libyuv
cd libyuv
git checkout ${branch[2]}
cmake -B build -G Ninja -S ./ \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_C_FLAGS="$CFLG" -DCMAKE_CXX_FLAGS="$CFLG" -DCMAKE_EXE_LINKER_FLAGS="$LFLG" \
    -Wno-dev
ninja -C build yuv
cd ../..

printf '\n:: Build libavif ::\n'
cmake -B build -G Ninja -S ./ \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DAVIF_CODEC_AOM=ON \
    -DAVIF_LOCAL_AOM=ON \
    -DAVIF_LOCAL_ZLIBPNG=ON \
    -DAVIF_LOCAL_JPEG=ON \
    -DAVIF_LOCAL_LIBYUV=ON \
    -DAVIF_BUILD_APPS=ON \
    -DCMAKE_C_FLAGS="$CFLG" -DCMAKE_CXX_FLAGS="$CFLG" -DCMAKE_EXE_LINKER_FLAGS="$LFLG -static"
ninja -C build
strip -s build/*.exe
