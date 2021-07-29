#!/bin/bash
export CC=clang CXX=clang++
rm -rf flac
git clone https://github.com/xiph/flac.git --recursive
cd flac
./autogen.sh
CFLAGS='-ffunction-sections -fdata-sections' \
CXXFLAGS='-ffunction-sections -fdata-sections' \
LDFLAGS='-Wl,--gc-sections -Wl,--no-export-dynamic -fstack-protector-strong -lssp' \
./configure --disable-shared --enable-static --disable-ogg --enable-64-bit-words --disable-doxygen-docs --disable-xmms-plugin --disable-cpplibs --disable-examples
make -j 4
strip -s src/flac/flac.exe