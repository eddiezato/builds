#!/bin/bash
export CC=clang CXX=clang++
rm -rf qt-avif-image-plugin
git clone --depth 1 https://github.com/novomesk/qt-avif-image-plugin.git
printf '\n:: Build libavif ::\n'
cd libavif
rm -rf build.qavif
cmake -B build.qavif -G Ninja -S ./ \
    -DCMAKE_INSTALL_PREFIX=/mingw64 \
    -DCMAKE_BUILD_TYPE=Release \
    -DAVIF_CODEC_DAV1D=ON \
    -DAVIF_LOCAL_DAV1D=ON \
    -DAVIF_LOCAL_LIBYUV=ON \
    -DAVIF_BUILD_APPS=ON \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic'
ninja -C build.qavif
cd ../qt-avif-image-plugin
sed -i 's#LIBS += -lavif#LIBS += ~/libavif/build.qavif/libavif.dll.a ~/libavif/ext/dav1d/build/src/libdav1d.a ~/libavif/ext/libyuv/build/libyuv.a\nINCLUDEPATH += ~/libavif/include#' \
    qt-avif-image-plugin.pro
printf '\nQMAKE_CFLAGS *= \"-march=native -pipe\"\nQMAKE_CXXFLAGS *= \"-march=native -pipe\"' >> qt-avif-image-plugin.pro
qmake "CONFIG += optimize_full" qt-avif-image-plugin.pro
make -j 4