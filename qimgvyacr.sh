#!/bin/bash
rm -rf qimgvyacr
mkdir qimgvyacr
cp ~/qimgv/build/qimgv/qimgv.exe ~/qimgvyacr/
cp ~/yacreader/build/release64/YACReader.exe ~/qimgvyacr/
windeployqt ~/qimgvyacr/qimgv.exe --compiler-runtime --no-translations
windeployqt ~/qimgvyacr/YACReader.exe --compiler-runtime --no-translations
rm -rf ~/qimgvyacr/{audio,bearer,playlistformats}
rm -rf ~/qimgvyacr/mediaservice/qtmedia_audioengine.dll
printf '\nCopy dependencies...\n'
cp /mingw64/bin/{libbz2-1.dll,\
libcrypto-1_1-x64.dll,\
libcurl-4.dll,\
libdeflate.dll,\
libdouble-conversion.dll,\
libexiv2.dll,\
libexpat-1.dll,\
libfreetype-6.dll,\
libgfortran-5.dll,\
libglib-2.0-0.dll,\
libgraphite2.dll,\
libharfbuzz-0.dll,\
libiconv-2.dll,\
libicudt68.dll,\
libicuin68.dll,\
libicuuc68.dll,\
libidn2-0.dll,\
libintl-8.dll,\
libjasper-4.dll,\
libjbig-0.dll,\
libjpeg-8.dll,\
liblzma-5.dll,\
libnghttp2-14.dll,\
libopenblas.dll,\
libopencv_core452.dll,\
libopencv_imgproc452.dll,\
libpcre-1.dll,\
libpcre2-16-0.dll,\
libpng16-16.dll,\
libpsl-5.dll,\
libquadmath-0.dll,\
libssh2-1.dll,\
libssl-1_1-x64.dll,\
libtiff-5.dll,\
libunistring-2.dll,\
libwebp-7.dll,\
libwebpdemux-2.dll,\
libwebpmux-3.dll,\
libzstd.dll,\
tbb.dll,\
zlib1.dll} ~/qimgvyacr/
cp ~/libjxl/build/third_party/brotli/{libbrotlicommon.dll,libbrotlidec.dll,libbrotlienc.dll} ~/qimgvyacr/
cp ~/libjxl/build/{libjxl.dll,libjxl_threads.dll} ~/qimgvyacr/
cp ~/libavif/build/libavif.dll ~/qimgvyacr/
cp ~/qt-jpegxl-image-plugin/plugins/imageformats/qjpegxl.dll ~/qimgvyacr/imageformats/
cp ~/qt-avif-image-plugin/plugins/imageformats/qavif.dll ~/qimgvyacr/imageformats/
curl -#O https://www.7-zip.org/a/7z2103-x64.exe
7z e 7z2103-x64.exe -oYACReader_w64/utils/ 7z.dll
rm -f 7z2103-x64.exe
printf 'Strip size...'
strip -s ~/qimgvyacr/*.{exe,dll}
strip -s ~/qimgvyacr/imageformats/*.dll