#!/bin/bash
export CC=clang CXX=clang++
#git clone https://github.com/novomesk/qt-avif-image-plugin.git --recursive
cd qt-avif-image-plugin
rm -rf plugins
git pull
./build_libqavif_dynamic.sh 
cd ~
#git clone https://github.com/novomesk/qt-jpegxl-image-plugin.git
cd qt-jpegxl-image-plugin
rm -rf plugins
git pull
./build_libqjpegxl_dynamic.sh 