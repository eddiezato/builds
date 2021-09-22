#!/bin/bash
export CC=clang CXX=clang++
rm -rf quickviewer
git clone --depth 1 https://github.com/kanryu/quickviewer.git
rm -rf ~/quickviewer/Qt7z/Qt7z/7zip/{Asm,C,CPP,DOC}
curl -#O https://www.7-zip.org/a/7z2103-src.7z
7z x 7z2103-src.7z -oquickviewer/Qt7z/Qt7z/7zip -y
rm -f 7z2103-src.7z
cd quickviewer/Qt7z/Qt7z
rm -rf lib7zip && git clone --depth 1 https://github.com/kanryu/lib7zip.git
cd ../../QuickViewer/src
rm -rf qactionmanager && git clone --depth 1 https://github.com/kanryu/qactionmanager.git
rm -rf qfullscreenframe && git clone --depth 1 https://github.com/kanryu/qfullscreenframe.git
rm -rf qlanguageselector && git clone --depth 1 https://github.com/kanryu/qlanguageselector.git
rm -rf qnamedpipe && git clone --depth 1 https://github.com/kanryu/qnamedpipe.git
cd ../../ResizeHalf
rm -rf ResizeHalf && git clone --depth 1 https://github.com/chikuzen/ResizeHalf.git
cd ../easyexif
rm -rf easyexif && git clone --depth 1 https://github.com/mayanklahiri/easyexif.git
cd ../zimg
rm -rf zimg && git clone -b v2.5 --depth 1 https://github.com/sekrit-twc/zimg.git
cd ..
printf 'Apply custom patches '
sed -i 's/#include \"MyTypes.h\"/#include \"MyTypes.h\"\n#include \"common.h\"/' Qt7z/Qt7z/7zip/CPP/Common/MyBuffer.h && printf '.'
sed -i 's/#include <string.h>/#include <string.h>\n#include \"common.h\"/' Qt7z/Qt7z/7zip/CPP/Common/MyVector.h && printf '.'
sed -i 's/DEFINES += QV_WITH_LUMINOR/#DEFINES += QV_WITH_LUMINOR/' QVproject.pri && printf '.'
sed -i 's/SUBDIRS += AssociateFilesWithQuickViewer/#SUBDIRS += AssociateFilesWithQuickViewer/' QVproject.pro && printf '.'
sed -i 's/-luuid/-luuid\n    QMAKE_CFLAGS += -march=native -pipe\n    QMAKE_CXXFLAGS += -march=native -pipe/' QuickViewer/QuickViewer.pro && printf '.'
sed -i 's/QMAKE_POST_LINK.*//' QuickViewer/QuickViewer.pro && printf '.'
sed -i 's/#include \"matrix3.h\"/#include <stddef.h>\n#include \"matrix3.h\"/' zimg/zimg/src/zimg/colorspace/matrix3.cpp && printf '.\n'
mkdir build
cd build
qmake "CONFIG += optimize_full" -o Makefile -recursive ../QVProject.pro
make -j 4