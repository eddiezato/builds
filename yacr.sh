#!/bin/bash
export CC=clang CXX=clang++
rm -rf yacreader
git clone --depth 1 https://github.com/YACReader/yacreader.git
curl -#O https://www.7-zip.org/a/7z2103-src.7z
7z x 7z2103-src.7z -oyacreader/compressed_archive/lib7zip -y
rm -f 7z2103-src.7z
cd yacreader
printf 'Apply custom patches .'
printf 'TEMPLATE = subdirs\nSUBDIRS = YACReader' > YACReader2.pro
sed -i 's#/DNDEBUG#-DNDEBUG#' config.pri && printf '.'
sed -i 's/-luser32/-luser32 -luuid/' YACReader/YACReader.pro && printf '.'
sed -i 's/QMAKE_CXXFLAGS_RELEASE.*/QMAKE_CXXFLAGS_RELEASE *= -march=native -pipe/' YACReader/YACReader.pro && printf '.'
sed -i 's/QMAKE_LFLAGS_RELEASE.*/QMAKE_LFLAGS_RELEASE += -LTCG/' YACReader/YACReader.pro && printf '.'
sed -i 's/.*afterLaunchTasks();.*//' YACReader/main_window_viewer.cpp && printf '.'
sed -i 's/.*NewController.*//' YACReader/main_window_viewer.cpp && printf '.'
sed -i 's#.*QStandardPaths::DataLocation.*#    return (QCoreApplication::applicationDirPath() + "/conf");#' common/yacreader_global.cpp && printf '.'
sed -i 's/#include <QDataStream>/#include <QDataStream>\n#include <QCoreApplication>/' common/yacreader_global.h && printf '.'
sed -i 's#.*rounded_corners_dialog.h.*#        $$PWD/rounded_corners_dialog.h#' custom_widgets/custom_widgets_yacreader.pri && printf '.'
sed -i 's#.*rounded_corners_dialog.cpp.*#        $$PWD/rounded_corners_dialog.cpp#' custom_widgets/custom_widgets_yacreader.pri && printf '.'
sed -i 's/.*whats_new_.*//' custom_widgets/custom_widgets_yacreader.pri && printf '.\n'
mkdir build
cd build
qmake "CONFIG += optimize_full no_pdf" ../YACReader2.pro
make -j 4