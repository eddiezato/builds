#!/bin/bash
export CC=clang CXX=clang++
rm -rf yacreader
git clone https://github.com/YACReader/yacreader.git --recursive
curl -#O https://www.7-zip.org/a/7z2103-src.7z
7z x 7z2103-src.7z -oyacreader/compressed_archive/lib7zip -y
rm -f 7z2103-src.7z
cd yacreader
git apply ~/yacr.patch
rm -rf build
mkdir build
cd build
qmake "CONFIG += optimize_full no_pdf" ../YACReader.pro
make -j 4