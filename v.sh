#!/bin/bash
while getopts 'AajrqQvVyY' flag ; do
    case "${flag}" in
        A) QAVIF=1; QJXL=1; QRAW=1; QIMGV=1; QIMGVD=1; QVWR=1; QVWRD=1; YACR=1; YACRD=1;;   # build all
        a) QAVIF=1 ;;   # build libavif and qavif
        j) QJXL=1 ;;    # build libjxl and qjpegxl
        r) QRAW=1 ;;    # build qtraw
        q) QIMGV=1 ;;   # build qimgv
        Q) QIMGVD=1 ;;  # create qimgv distributive
        v) QVWR=1 ;;    # build quickviewer
        V) QVWRD=1 ;;   # create quickviewer distributive
        y) YACR=1 ;;    # build yacreader
        Y) YACRD=1 ;;   # create yacreader distributive
    esac
done

set -e
export CC=clang CXX=clang++
CFL='-ffunction-sections -fdata-sections -march=native -mtune=native -O3 -pipe'
LDFL='-Wl,--gc-sections'
QCFL='\nQMAKE_CFLAGS *= -march=native -mtune=native -pipe\nQMAKE_CXXFLAGS *= -march=native -mtune=native -pipe'
MGNT='\e[1;35m'
RST='\e[0m'

mkdir -p builds
cd builds

# build qavif
if [[ $QAVIF == 1 ]] ; then
    rm -rf qt-avif-image-plugin

    printf "\n${MGNT}:: Prepare qavif ::${RST}\n"
    git clone --depth 1 https://github.com/novomesk/qt-avif-image-plugin.git
    cd qt-avif-image-plugin

    printf "\n${MGNT}:: Prepare libavif ::${RST}\n"
    git clone --depth 1 --branch v0.10.1 https://github.com/AOMediaCodec/libavif.git

    printf "\n${MGNT}:: Build dav1d ::${RST}\n"
    cd libavif/ext
    branch=($(grep -i "git clone" dav1d.cmd))
    git clone -b ${branch[3]} --depth 1 https://code.videolan.org/videolan/dav1d.git
    cd dav1d
    mkdir build
    CFLAGS="$CFL" CXXFLAGS="$CFL" LDFLAGS="$LDFL" meson --default-library=static --buildtype=release -Denable_tools=false -Denable_tests=false build ./
    ninja -C build
    cd ..

    printf "\n${MGNT}:: Build libyuv ::${RST}\n"
    branch=($(grep -i "git checkout" libyuv.cmd))
    git clone --single-branch https://chromium.googlesource.com/libyuv/libyuv
    cd libyuv
    git checkout ${branch[2]}
    cmake -B build -G Ninja -S ./ \
        -DBUILD_SHARED_LIBS=OFF \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_FLAGS="$CFL" -DCMAKE_CXX_FLAGS="$CFL" -DCMAKE_EXE_LINKER_FLAGS="$LDFL" \
        -Wno-dev
    ninja -C build yuv
    cd ../..

    printf "\n${MGNT}:: Build libavif ::${RST}\n"
    cmake -B build -G Ninja -S ./ \
        -DCMAKE_BUILD_TYPE=Release \
        -DAVIF_CODEC_DAV1D=ON \
        -DAVIF_LOCAL_DAV1D=ON \
        -DAVIF_LOCAL_LIBYUV=ON \
        -DCMAKE_C_FLAGS="$CFL" -DCMAKE_CXX_FLAGS="$CFL" -DCMAKE_EXE_LINKER_FLAGS="$LDFL"
    ninja -C build
    cd ..
        
    sed -i 's|LIBS += -lavif|LIBS += ../libavif/build/libavif.dll.a ../libavif/ext/dav1d/build/src/libdav1d.a ../libavif/ext/libyuv/build/libyuv.a\nINCLUDEPATH += ../libavif/include|' \
        qt-avif-image-plugin.pro
    printf "$QCFL" >> qt-avif-image-plugin.pro
    mkdir qt5 qt6
    printf "\n${MGNT}:: Build qavif-qt5 ::${RST}\n"
    cd qt5
    qmake "CONFIG += optimize_full" ../qt-avif-image-plugin.pro
    make -j 4
    printf "\n${MGNT}:: Build qavif-qt6 ::${RST}\n"
    cd ../qt6
    qmake-qt6 "CONFIG += optimize_full" ../qt-avif-image-plugin.pro
    make -j 4
    cd ../..
fi

# build qjpegxl
if [[ $QJXL == 1 ]] ; then
    rm -rf qt-jpegxl-image-plugin

    printf "\n${MGNT}:: Prepare qjpegxl ::${RST}\n"
    git clone --depth 1 https://github.com/novomesk/qt-jpegxl-image-plugin.git
    cd qt-jpegxl-image-plugin

    printf "\n${MGNT}:: Build libjxl ::${RST}\n"
    git clone --depth 1 https://github.com/libjxl/libjxl.git
    cd libjxl/third_party
    git clone --depth 1 https://skia.googlesource.com/skcms
    git clone --depth 1 https://github.com/webmproject/sjpeg.git
    git clone --depth 1 https://github.com/libjxl/testdata
    cd ..
    cmake -B build -G Ninja -S ./ \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_TESTING=OFF \
        -DJPEGXL_ENABLE_TOOLS=OFF \
        -DJPEGXL_ENABLE_DOXYGEN=OFF \
        -DJPEGXL_ENABLE_MANPAGES=OFF \
        -DJPEGXL_ENABLE_BENCHMARK=OFF \
        -DJPEGXL_ENABLE_EXAMPLES=OFF \
        -DJPEGXL_ENABLE_JNI=OFF \
        -DJPEGXL_ENABLE_OPENEXR=OFF \
        -DJPEGXL_WARNINGS_AS_ERRORS=OFF \
        -DJPEGXL_FORCE_SYSTEM_BROTLI=ON \
        -DJPEGXL_FORCE_SYSTEM_LCMS2=ON \
        -DJPEGXL_FORCE_SYSTEM_HWY=ON \
        -DCMAKE_C_FLAGS="$CFL" -DCMAKE_CXX_FLAGS="$CFL" -DCMAKE_EXE_LINKER_FLAGS="$LDFL" \
        -Wno-dev
    ninja -C build
    cd ..

    sed -i 's|LIBS += -ljxl -ljxl_threads|INCLUDEPATH += ../libjxl/lib/include ../libjxl/build/lib/include\nLIBS += ../libjxl/build/lib/libjxl.dll.a ../libjxl/build/lib/libjxl_threads.dll.a|' \
        qt-jpegxl-image-plugin.pro
    printf "$QCFL" >> qt-jpegxl-image-plugin.pro
    mkdir qt5 qt6
    printf "\n${MGNT}:: Build qjpegxl-qt5 ::${RST}\n"
    cd qt5
    qmake "CONFIG += optimize_full" ../qt-jpegxl-image-plugin.pro
    make -j 4
    printf "\n${MGNT}:: Build qjpegxl-qt6 ::${RST}\n"
    cd ../qt6
    qmake-qt6 "CONFIG += optimize_full" ../qt-jpegxl-image-plugin.pro
    make -j 4
    cd ../..
fi

# build qtraw
if [[ $QRAW == 1 ]] ; then
    rm -rf qtraw

    printf "\n${MGNT}:: Build qtraw-qt6 ::${RST}\n"
    git clone --depth 1 https://gitlab.com/mardy/qtraw.git
    cd qtraw
    printf "$QCFL" >> qtraw.pro
    sed -i 's|if (!format.isEmpty())|//if (!format.isEmpty())|;s|return 0;|//return 0;|' src/main.cpp
    mkdir qt6
    cd qt6
    qmake-qt6 "CONFIG += optimize_full" ../qtraw.pro
    make -j 4
    cd ../..
fi

# build qimgv with exiv2 and opencv
if [[ $QIMGV == 1 ]] ; then
    rm -rf qimgv

    printf "\n${MGNT}:: Prepare qimgv ::${RST}\n"
    git clone --depth 1 --branch v1.0.3-alpha https://github.com/easymodo/qimgv.git
    cd qimgv

    printf "\n${MGNT}:: Build exiv2 ::${RST}\n"
    git clone --branch 0.27-nightly --depth 1 https://github.com/Exiv2/exiv2.git
    cd exiv2
    cmake -B build -G Ninja -S ./ \
        -DCMAKE_INSTALL_PREFIX='../ext' \
        -DCMAKE_BUILD_TYPE=Release \
        -DEXIV2_ENABLE_WIN_UNICODE=ON \
        -DEXIV2_ENABLE_BMFF=ON \
        -DEXIV2_BUILD_SAMPLES=OFF \
        -DCMAKE_C_FLAGS="$CFL" -DCMAKE_CXX_FLAGS="$CFL -pthread" -DCMAKE_EXE_LINKER_FLAGS="$LDFL"
    ninja install -C build
    cd ..

    printf "\n${MGNT}:: Build opencv ::${RST}\n"
    git clone --depth 1 --branch 4.5.5 https://github.com/opencv/opencv.git
    cd opencv
    cmake -B build -G Ninja -S ./ \
        -DCMAKE_INSTALL_PREFIX='../ext' \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_LIST='core,imgproc' \
        -DWITH_1394=OFF \
        -DWITH_VTK=OFF \
        -DWITH_FFMPEG=OFF \
        -DWITH_GSTREAMER=OFF \
        -DWITH_DSHOW=OFF \
        -DWITH_QUIRC=OFF \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_C_FLAGS="$CFL" -DCMAKE_CXX_FLAGS="$CFL" -DCMAKE_EXE_LINKER_FLAGS="$LDFL"
    ninja install -C build
    cd ..

    printf "\n${MGNT}:: Build qimgv ::${RST}\n"
    sed -i 's|opencv4/||' qimgv/3rdparty/QtOpenCV/cvmatandqimage.{h,cpp}
    cmake -B build -G Ninja -S ./ \
        -DCMAKE_BUILD_TYPE=Release \
        -DVIDEO_SUPPORT=OFF \
        -DOPENCV_SUPPORT=ON \
        -DEXIV2=ON \
        -DCMAKE_PREFIX_PATH=$(realpath 'ext') \
        -DCMAKE_C_FLAGS="$CFL" -DCMAKE_CXX_FLAGS="$CFL" -DCMAKE_EXE_LINKER_FLAGS="$LDFL"
    ninja -C build
    cd ..
fi

# create qimgv distributive
if [[ $QIMGVD == 1 ]] ; then
    rm -rf qimgv_w64

    printf "\n${MGNT}:: Create qimgv distributive ::${RST}\n"
    mkdir qimgv_w64
    cp qimgv/build/qimgv/qimgv.exe qimgv_w64/
    windeployqt-qt6 qimgv_w64/qimgv.exe --compiler-runtime --no-translations --qtpaths /clang64/bin/qtpaths-qt6.exe
    
    printf 'Copying dependencies '
    cp qt-jpegxl-image-plugin/libjxl/build/{libjxl.dll,libjxl_threads.dll} qimgv_w64/ && printf '.'
    cp qt-avif-image-plugin/libavif/build/libavif.dll qimgv_w64/ && printf '.'
    cp qimgv/ext/{bin/libexiv2.dll,x64/mingw/bin/{libopencv_core455.dll,libopencv_imgproc455.dll}} qimgv_w64/ && printf '.'
    cp qt-jpegxl-image-plugin/qt6/plugins/imageformats/qjpegxl.dll qimgv_w64/imageformats/ && printf '.'
    cp qt-avif-image-plugin/qt6/plugins/imageformats/qavif.dll qimgv_w64/imageformats/ && printf '.'
    cp qtraw/qt6/src/imageformats/qtraw.dll qimgv_w64/imageformats/ && printf '.'
    mkdir -p qimgv_w64/data/mime/packages && cp qt-jpegxl-image-plugin/libjxl/plugins/mime/image-jxl.xml qimgv_w64/data/mime/packages/ && printf '.'
    while
        files2=$files1
        files1=$(ldd qimgv_w64/{*.{exe,dll},imageformats/*.dll} | grep '/clang64/bin/' | grep -v 'Qt6' | sed 's/.* => //;s/ (.*//' | sort -u)
        printf '.'
        for f in $files1; do
            cp -u $f qimgv_w64/
        done
        [[ $files1 != $files2 ]]
    do :; done
    echo 'ok'

    printf 'Reduce file sizes .'
    strip -s qimgv_w64/{*.{exe,dll},{iconengines,imageformats,platforms,styles}/*.dll}
    printf 'ok\n'
fi

# build quickviewer
if [[ $QVWR == 1 ]] ; then
    rm -rf quickviewer

    printf "\n${MGNT}:: Build quickviewer ::${RST}\n"
    git clone --depth 1 https://github.com/kanryu/quickviewer.git
    rm -rf quickviewer/Qt7z/Qt7z/7zip/{Asm,C,CPP,DOC}
    curl -#O https://www.7-zip.org/a/7z2107-src.7z
    7z x 7z2107-src.7z -oquickviewer/Qt7z/Qt7z/7zip -y
    rm -f 7z2107-src.7z
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
    sed -i 's|#include \"MyTypes.h\"|#include \"MyTypes.h\"\n#include \"common.h\"|' Qt7z/Qt7z/7zip/CPP/Common/MyBuffer.h && printf '.'
    sed -i 's|#include <string.h>|#include <string.h>\n#include \"common.h\"|' Qt7z/Qt7z/7zip/CPP/Common/MyVector.h && printf '.'
    sed -i 's|Time: prop = 0|Time: prop = (UInt32)0|g' Qt7z/Qt7z/lib7zip/src/7ZipArchiveOpenCallback.cpp && printf '.'
    sed -i 's|DEFINES += QV_WITH_LUMINOR|#DEFINES += QV_WITH_LUMINOR|' QVproject.pri && printf '.'
    sed -i 's|SUBDIRS += AssociateFilesWithQuickViewer|#SUBDIRS += AssociateFilesWithQuickViewer|' QVproject.pro && printf '.'
    sed -i 's|-luuid|-luuid\n    QMAKE_CFLAGS += -march=native -mtune=native -pipe\n    QMAKE_CXXFLAGS += -march=native -mtune=native -pipe|
        s|QMAKE_POST_LINK.*||' QuickViewer/QuickViewer.pro && printf '.'
    sed -i 's|#include \"matrix3.h\"|#include <stddef.h>\n#include \"matrix3.h\"|' zimg/zimg/src/zimg/colorspace/matrix3.cpp && printf '.'
    sed -i 's|-lfileloader|-lfileloader -luuid|' qvtest/qvtest.pro && printf '.\n'
    mkdir build
    cd build
    qmake "CONFIG += optimize_full" -o Makefile -recursive ../QVProject.pro
    make -j 4
    cd ../..
fi

# create quickviewer distributive
if [[ $QVWRD == 1 ]] ; then
    rm -rf QuickViewer_w64

    printf "\n${MGNT}:: Create quickviewer distributive ::${RST}\n"
    mkdir QuickViewer_w64
    cp quickviewer/build/bin/QuickViewer.exe QuickViewer_w64/
    windeployqt QuickViewer_w64/QuickViewer.exe --no-translations
    
    printf 'Copying dependencies '
    cp qt-jpegxl-image-plugin/libjxl/build/{libjxl.dll,libjxl_threads.dll} QuickViewer_w64/ && printf '.'
    cp qt-avif-image-plugin/libavif/build/libavif.dll QuickViewer_w64/ && printf '.'
    cp qt-jpegxl-image-plugin/qt5/plugins/imageformats/qjpegxl.dll QuickViewer_w64/imageformats/ && printf '.'
    cp qt-avif-image-plugin/qt5/plugins/imageformats/qavif.dll QuickViewer_w64/imageformats/ && printf '.'
    while
        files2=$files1
        files1=$(ldd QuickViewer_w64/{*.{exe,dll},imageformats/*.dll} | grep '/clang64/bin/' | grep -v 'Qt5' | sed 's/.* => //;s/ (.*//' | sort -u)
        printf '.'
        for f in $files1; do
            cp -u $f QuickViewer_w64/
        done
        [[ $files1 != $files2 ]]
    do :; done
    cp -u /usr/bin/7z.dll QuickViewer_w64/ && printf '.'
    echo 'ok'

    printf 'Reduce file sizes .'
    strip -s QuickViewer_w64/{*.{exe,dll},{iconengines,imageformats,platforms,styles}/*.dll}
    printf 'ok\n'
fi

# build yacreader
if [[ $YACR == 1 ]] ; then
    rm -rf yacreader

    printf "\n${MGNT}:: Build yacreader ::${RST}\n"
    git clone --depth 1 https://github.com/YACReader/yacreader.git
    curl -#O https://www.7-zip.org/a/7z2107-src.7z
    7z x 7z2107-src.7z -oyacreader/compressed_archive/lib7zip -y
    rm -f 7z2107-src.7z
    cd yacreader
    printf 'Apply custom patches .'
    printf 'TEMPLATE = subdirs\nSUBDIRS = YACReader' > YACReader2.pro
    sed -i 's|.*std:c++17.*||' config.pri && printf '.'
    sed -i 's|-luser32|-luser32 -luuid|
        s|QMAKE_CXXFLAGS_RELEASE.*|QMAKE_CXXFLAGS_RELEASE *= -march=native -mtune=native -pipe|
        s|QMAKE_LFLAGS_RELEASE.*|QMAKE_LFLAGS_RELEASE += -LTCG|' YACReader/YACReader.pro && printf '.'
    sed -i 's|QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation)|(QCoreApplication::applicationDirPath() + "/conf");|' common/yacreader_global.cpp && printf '.'
    sed -i 's|#include <QDataStream>|#include <QDataStream>\n#include <QCoreApplication>|' common/yacreader_global.h && printf '.'
    sed -i 's|QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation)|QCoreApplication::applicationDirPath()|
        s|/YACReader/YACReaderCommon.ini|/conf/YACReaderCommon.ini|' custom_widgets/whats_new_controller.cpp && printf '.'
    sed -i 's|#include <QObject>|#include <QObject>\n#include <QCoreApplication>|' custom_widgets/whats_new_dialog.h && printf '.\n'
    mkdir build
    cd build
    qmake-qt6 "CONFIG += optimize_full no_pdf" ../YACReader2.pro
    make -j 4
    cd ..
fi

# create yacreader distributive
if [[ $YACRD == 1 ]] ; then
    rm -rf YACReader_w64

    printf "\n${MGNT}:: Create quickviewer distributive ::${RST}\n"
    mkdir -p YACReader_w64/utils
    cp yacreader/build/release64/YACReader.exe YACReader_w64/
    windeployqt-qt6 YACReader_w64/YACReader.exe  --compiler-runtime --no-translations --qtpaths /clang64/bin/qtpaths-qt6.exe
    
    printf 'Copying dependencies '
    cp qt-jpegxl-image-plugin/libjxl/build/{libjxl.dll,libjxl_threads.dll} YACReader_w64/ && printf '.'
    cp qt-avif-image-plugin/libavif/build/libavif.dll YACReader_w64/ && printf '.'
    cp qt-jpegxl-image-plugin/qt6/plugins/imageformats/qjpegxl.dll YACReader_w64/imageformats/ && printf '.'
    cp qt-avif-image-plugin/qt6/plugins/imageformats/qavif.dll YACReader_w64/imageformats/ && printf '.'
    while
        files2=$files1
        files1=$(ldd YACReader_w64/{*.{exe,dll},imageformats/*.dll} | grep '/clang64/bin/' | grep -v 'Qt6' | sed 's/.* => //;s/ (.*//' | sort -u)
        printf '.'
        for f in $files1; do
            cp -u $f YACReader_w64/
        done
        [[ $files1 != $files2 ]]
    do :; done
    cp -u /usr/bin/7z.dll YACReader_w64/utils/ && printf '.'
    echo 'ok'

    printf 'Reduce file sizes .'
    strip -s YACReader_w64/{*.{exe,dll},{iconengines,imageformats,platforms,styles,utils}/*.dll}
    printf 'ok\n'
fi