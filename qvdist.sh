#!/bin/bash
rm -rf ~/QuickViewer_w64
mkdir -p ~/QuickViewer_w64/database
cp ~/quickviewer/build/bin/QuickViewer.exe ~/QuickViewer_w64/
windeployqt ~/QuickViewer_w64/QuickViewer.exe --compiler-runtime --no-translations
rm -f ~/QuickViewer_w64/sqldrivers/{qsqlibase.dll,qsqlmysql.dll}
cp /mingw64/share/qt5/plugins/platforms/qdirect2d.dll ~/QuickViewer_w64/platforms/
printf '\nCopy dependencies...\n'
cp /mingw64/bin/{libbz2-1.dll,\
libdeflate.dll,\
libdouble-conversion.dll,\
libfreetype-6.dll,\
libglib-2.0-0.dll,\
libgraphite2.dll,\
libharfbuzz-0.dll,\
libiconv-2.dll,\
libicudt68.dll,\
libicuin68.dll,\
libicuuc68.dll,\
libintl-8.dll,\
libjasper-4.dll,\
libjbig-0.dll,\
libjpeg-8.dll,\
libLerc.dll,\
liblzma-5.dll,\
libpcre-1.dll,\
libpcre2-16-0.dll,\
libpng16-16.dll,\
libtiff-5.dll,\
libwebp-7.dll,\
libwebpdemux-2.dll,\
libwebpmux-3.dll,\
libzstd.dll,\
zlib1.dll} ~/QuickViewer_w64/
cp ~/libjxl/build/third_party/brotli/{libbrotlicommon.dll,libbrotlidec.dll,libbrotlienc.dll} ~/QuickViewer_w64/
cp ~/libjxl/build/{libjxl.dll,libjxl_threads.dll} ~/QuickViewer_w64/
cp ~/libavif/build/libavif.dll ~/QuickViewer_w64/
cp ~/qt-jpegxl-image-plugin/plugins/imageformats/qjpegxl.dll ~/QuickViewer_w64/imageformats/
cp ~/qt-avif-image-plugin/plugins/imageformats/qavif.dll ~/QuickViewer_w64/imageformats/
curl -#O https://www.7-zip.org/a/7z2103-x64.exe
7z e 7z2103-x64.exe -oQuickViewer_w64/ 7z.dll
rm -f 7z2103-x64.exe
printf 'Strip size...'
strip -s ~/QuickViewer_w64/iconengines/*.dll
strip -s ~/QuickViewer_w64/imageformats/*.dll
strip -s ~/QuickViewer_w64/platforms/*.dll
strip -s ~/QuickViewer_w64/sqldrivers/*.dll
strip -s ~/QuickViewer_w64/styles/*.dll
strip -s ~/QuickViewer_w64/*.{exe,dll}