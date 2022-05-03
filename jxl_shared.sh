#!/bin/bash
export CC=clang CXX=clang++
rm -rf libjxl
git clone --depth 1 https://github.com/libjxl/libjxl.git
cd libjxl/third_party
git clone --depth 1 https://skia.googlesource.com/skcms
git clone --depth 1 https://github.com/webmproject/sjpeg.git
git clone --depth 1 https://github.com/libjxl/testdata
cd ..
cmake -B build -G Ninja -S ./ \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTING=OFF \
    -DJPEGXL_ENABLE_DEVTOOLS=ON \
    -DJPEGXL_ENABLE_DOXYGEN=OFF \
    -DJPEGXL_ENABLE_MANPAGES=OFF \
    -DJPEGXL_ENABLE_BENCHMARK=OFF \
    -DJPEGXL_ENABLE_EXAMPLES=OFF \
    -DJPEGXL_ENABLE_JNI=OFF \
    -DJPEGXL_ENABLE_OPENEXR=OFF \
    -DJPEGXL_WARNINGS_AS_ERRORS=OFF \
    -DJPEGXL_FORCE_SYSTEM_BROTLI=ON \
    -DJPEGXL_FORCE_SYSTEM_LCMS2=ON \
    -DJPEGXL_FORCE_SYSTEM_HWY=ON \
    -Wno-dev \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections'
ninja -C build
