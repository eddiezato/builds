#!/bin/bash
export CC=clang CXX=clang++
rm -rf libjxl
git clone --depth 1 https://github.com/libjxl/libjxl.git
cd libjxl/third_party
git clone --depth 1 --branch v1.0.9 https://github.com/google/brotli.git
git clone --depth 1 --branch 0.16.0 https://github.com/google/highway.git
git clone --depth 1 --branch lcms2.13.1 https://github.com/mm2/Little-CMS.git
git clone --depth 1 --branch v1.6.37 https://github.com/glennrp/libpng.git
git clone --depth 1 --branch v1.2.12 https://github.com/madler/zlib.git
git clone --depth 1 https://skia.googlesource.com/skcms
git clone --depth 1 https://github.com/webmproject/sjpeg.git
git clone --depth 1 https://github.com/gflags/gflags.git
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
    -DJPEGXL_BUNDLE_GFLAGS=ON \
    -DJPEGXL_BUNDLE_LIBPNG=ON \
    -DJPEGXL_ENABLE_JNI=OFF \
    -DJPEGXL_ENABLE_OPENEXR=OFF \
    -DJPEGXL_STATIC=ON \
    -DJPEGXL_WARNINGS_AS_ERRORS=OFF \
    -Wno-dev \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections'
ninja -C build
strip -s build/tools/*.exe
