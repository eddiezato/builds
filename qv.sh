#!/bin/bash
export CC=clang CXX=clang++
rm -rf quickviewer
git clone https://github.com/kanryu/quickviewer.git --recursive
rm -rf ~/quickviewer/Qt7z/Qt7z/7zip/{Asm,C,CPP,DOC}
curl -#O https://www.7-zip.org/a/7z2103-src.7z
7z x 7z2103-src.7z -oquickviewer/Qt7z/Qt7z/7zip -y
rm -f 7z2103-src.7z
cd quickviewer
git apply ~/qv.patch
git apply ~/qv7z.patch
rm -rf build
mkdir build
cd build
qmake "CONFIG += optimize_full" -o Makefile -recursive ../QVProject.pro
make -j 4