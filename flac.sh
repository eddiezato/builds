#!/bin/bash
export CC=clang CXX=clang++
rm -rf flac
git clone --depth 1 https://github.com/xiph/flac.git
cd flac
./autogen.sh
CPPFLAGS="-D_FORTIFY_SOURCE=0" \
    CFLAGS="-march=native -O3 -fno-common -fno-plt -fno-stack-protector -fno-math-errno -fno-trapping-math -pipe" \
    CXXFLAGS="$CFLAGS" \
    LDFLAGS="-Wl,-O1,--sort-common,--as-needed ${CFLAGS}" \
    ./configure --disable-shared \
                --enable-static \
                --disable-ogg \
                --disable-xmms-plugin \
                --disable-rpath \
                --enable-64-bit-words \
                --disable-stack-smash-protection \
                --disable-examples
make -j 4
strip -s src/flac/flac.exe