#!/bin/bash
rm -rf ~/YACReader_w64
mkdir ~/YACReader_w64
cp ~/yacreader/build/release64/YACReader.exe ~/YACReader_w64/
windeployqt ~/YACReader_w64/YACReader.exe --compiler-runtime --no-translations
rm -rf ~/YACReader_w64/{audio,bearer,playlistformats}
rm -rf ~/YACReader_w64/mediaservice/qtmedia_audioengine.dll
printf '\nCopy dependencies...\n'
cp /mingw64/bin/{libbz2-1.dll,\
libbrotlicommon.dll,\
libbrotlidec.dll,\
libbrotlienc.dll,\
libdeflate.dll,\
libdouble-conversion.dll,\
libfreetype-6.dll,\
libglib-2.0-0.dll,\
libgraphite2.dll,\
libharfbuzz-0.dll,\
libiconv-2.dll,\
libicudt69.dll,\
libicuin69.dll,\
libicuuc69.dll,\
libintl-8.dll,\
libjasper-4.dll,\
libjbig-0.dll,\
libjpeg-8.dll,\
liblzma-5.dll,\
libmd4c.dll,\
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
curl -#O https://www.7-zip.org/a/7z2103-x64.exe
7z e 7z2103-x64.exe -oYACReader_w64/utils/ 7z.dll
rm -f 7z2103-x64.exe
printf 'Strip size...'
strip -s ~/YACReader_w64/iconengines/*.dll
strip -s ~/YACReader_w64/imageformats/*.dll
strip -s ~/YACReader_w64/mediaservice/*.dll
strip -s ~/YACReader_w64/platforms/*.dll
strip -s ~/YACReader_w64/styles/*.dll
strip -s ~/YACReader_w64/*.{exe,dll}