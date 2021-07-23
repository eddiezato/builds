#!/bin/bash
export CC=clang CXX=clang++
#git clone https://github.com/YACReader/yacreader.git --recursive
cd yacreader
git pull
#git apply mingw.patch
rm -rf build
mkdir build
cd build
qmake CONFIG+=no_pdf ../YACReader.pro
make -j 4