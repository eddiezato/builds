#!/bin/bash
export CC=clang CXX=clang++
rm -rf qt-jpegxl-image-plugin
git clone --depth 1 https://github.com/novomesk/qt-jpegxl-image-plugin.git
cd qt-jpegxl-image-plugin
printf '\nQMAKE_CFLAGS *= \"-march=native -pipe\"\nQMAKE_CXXFLAGS *= \"-march=native -pipe\"' >> qt-jpegxl-image-plugin.pro
qmake "CONFIG += optimize_full" qt-jpegxl-image-plugin.pro
make -j 4