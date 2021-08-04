#!/bin/bash
export CC=clang CXX=clang++
rm -rf qt-avif-image-plugin
git clone https://github.com/novomesk/qt-avif-image-plugin.git --recursive
cd qt-avif-image-plugin
git apply ~/qtavifplugin.patch
qmake "CONFIG += optimize_full" qt-avif-image-plugin.pro
make -j 4
cd ~
rm -rf qt-jpegxl-image-plugin
git clone https://github.com/novomesk/qt-jpegxl-image-plugin.git
cd qt-jpegxl-image-plugin
git apply ~/qtjxlplugin.patch
qmake "CONFIG += optimize_full" qt-jpegxl-image-plugin.pro
make -j 4