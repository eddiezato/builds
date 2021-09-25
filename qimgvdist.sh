#!/bin/bash
rm -rf ~/qimgv_w64
mkdir ~/qimgv_w64
cp ~/qimgv/build/qimgv/qimgv.exe ~/qimgv_w64/
windeployqt ~/qimgv_w64/qimgv.exe --compiler-runtime --no-translations
printf '\nCopy dependencies...\n'
cp /mingw64/bin/{libbz2-1.dll,\
libbrotlicommon.dll,\
libbrotlidec.dll,\
libbrotlienc.dll,\
libcrypto-1_1-x64.dll,\
libcurl-4.dll,\
libdeflate.dll,\
libdouble-conversion.dll,\
libexiv2.dll,\
libexpat-1.dll,\
libfreetype-6.dll,\
libgfortran-5.dll,\
libglib-2.0-0.dll,\
libgomp-1.dll,\
libgraphite2.dll,\
libharfbuzz-0.dll,\
libiconv-2.dll,\
libicudt69.dll,\
libicuin69.dll,\
libicuuc69.dll,\
libidn2-0.dll,\
libintl-8.dll,\
libjasper-4.dll,\
libjbig-0.dll,\
libjpeg-8.dll,\
liblcms2-2.dll,\
liblzma-5.dll,\
libmd4c.dll,\
libnghttp2-14.dll,\
libopenblas.dll,\
libopencv_core452.dll,\
libopencv_imgproc452.dll,\
libpcre-1.dll,\
libpcre2-16-0.dll,\
libpng16-16.dll,\
libpsl-5.dll,\
libquadmath-0.dll,\
libraw-20.dll,\
libssh2-1.dll,\
libssl-1_1-x64.dll,\
libtiff-5.dll,\
libunistring-2.dll,\
libwebp-7.dll,\
libwebpdemux-2.dll,\
libwebpmux-3.dll,\
libzstd.dll,\
tbb.dll,\
zlib1.dll} ~/qimgv_w64/
cp ~/libjxl/build/{libjxl.dll,libjxl_threads.dll} ~/qimgv_w64/
cp ~/libavif/build.qavif/libavif.dll ~/qimgv_w64/
cp ~/qt-jpegxl-image-plugin/plugins/imageformats/qjpegxl.dll ~/qimgv_w64/imageformats/
cp ~/qt-avif-image-plugin/plugins/imageformats/qavif.dll ~/qimgv_w64/imageformats/
cp ~/qtraw/build/src/imageformats/qtraw.dll ~/qimgv_w64/imageformats/
mkdir -p ~/qimgv_w64/data/mime/packages
cp ~/libjxl/plugins/mime/image-jxl.xml ~/qimgv_w64/data/mime/packages/
printf 'Strip size...'
strip -s ~/qimgv_w64/iconengines/*.dll
strip -s ~/qimgv_w64/imageformats/*.dll
strip -s ~/qimgv_w64/platforms/*.dll
strip -s ~/qimgv_w64/printsupport/*.dll
strip -s ~/qimgv_w64/styles/*.dll
strip -s ~/qimgv_w64/*.{exe,dll}