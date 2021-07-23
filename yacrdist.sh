#!/bin/bash
rm -rf YACReader_w64
mkdir YACReader_w64
cp ~/yacreader/build/release64/YACReader.exe ~/YACReader_w64/
windeployqt ~/YACReader_w64/YACReader.exe --compiler-runtime --no-translations
rm -rf ~/YACReader_w64/{audio,bearer,mediaservice,playlistformats}
printf '\nCopy dependencies...\n'
cp /mingw64/bin/{libbrotlicommon.dll,\
libbrotlidec.dll,\
libbrotlienc.dll,\
libbz2-1.dll,\
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
liblzma-5.dll,\
libpcre-1.dll,\
libpcre2-16-0.dll,\
libpng16-16.dll,\
libssl-1_1-x64.dll,\
libtiff-5.dll,\
libwebp-7.dll,\
libwebpdemux-2.dll,\
libwebpmux-3.dll,\
libzstd.dll,\
zlib1.dll} ~/YACReader_w64/
cp ~/libjxl/build/{libjxl.dll,libjxl_threads.dll} ~/YACReader_w64/
cp ~/libavif/build/libavif.dll ~/YACReader_w64/
cp ~/qt-jpegxl-image-plugin/plugins/imageformats/qjpegxl.dll ~/YACReader_w64/imageformats/
cp ~/qt-avif-image-plugin/plugins/imageformats/qavif.dll ~/YACReader_w64/imageformats/
printf 'Strip size...'
strip -s ~/YACReader_w64/*.{exe,dll}
strip -s ~/YACReader_w64/imageformats/*.dll