#!/bin/bash
export CC=clang CXX=clang++
rm -rf flac
git clone --depth 1 https://github.com/xiph/flac.git
cd flac
sed -i 's/find_package(Iconv)/#find_package(Iconv)/' CMakeLists.txt
sed -i 's/find_package(Intl)/#find_package(Intl)/' src/share/getopt/CMakeLists.txt
cmake -B build -G Ninja -S ./ \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_DOCS=OFF \
    -DINSTALL_MANPAGES=OFF \
    -DINSTALL_PKGCONFIG_MODULES=OFF \
    -DINSTALL_CMAKE_CONFIG_MODULE=OFF \
    -DWITH_OGG=OFF \
    -DENABLE_64_BIT_WORDS=ON \
    -DCMAKE_C_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_CXX_FLAGS='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe' \
    -DCMAKE_EXE_LINKER_FLAGS='-Wl,--gc-sections -static -fstack-protector-strong'
ninja -C build
strip -s build/objs/flac.exe
