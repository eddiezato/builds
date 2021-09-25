#!/bin/bash
export CC=clang CXX=clang++
rm -rf qtraw
git clone --depth 1 https://gitlab.com/mardy/qtraw.git
cd qtraw
printf '\nQMAKE_CFLAGS *= -march=native -pipe\nQMAKE_CXXFLAGS *= -march=native -pipe' >> qtraw.pro
mkdir build
cd build
qmake "CONFIG += optimize_full" ../qtraw.pro
make -j 4