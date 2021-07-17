#!/bin/bash
export CC=clang CXX=clang++
#git clone https://github.com/libjxl/libjxl.git --recursive
cd libjxl
git pull
./deps.sh
rm -rf build
cmake -B build -G Ninja -S ./ \
    -DCMAKE_INSTALL_PREFIX=/mingw64 \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTING=OFF \
    -DJPEGXL_ENABLE_DEVTOOLS=ON \
    -DJPEGXL_FORCE_SYSTEM_BROTLI=ON \
    -DJPEGXL_ENABLE_MANPAGES=OFF \
    -DJPEGXL_ENABLE_OPENEXR=OFF \
    -DJPEGXL_ENABLE_SKCMS=OFF \
    -DJPEGXL_ENABLE_EXAMPLES=OFF \
    -DJPEGXL_WARNINGS_AS_ERRORS=OFF \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build
ninja install -C build