#!/bin/bash

set -e -x

BASE_DIR=$PWD
BUILD_DIR=$BASE_DIR/build
BUILD_TMP_DIR=$BASE_DIR/build/tmp
THIRD_PARTY_DIR=$BASE_DIR/third_party
PROCS=8

source "library-versions.inc"

if [ ! -d $BUILD_DIR ]; then
    mkdir $BUILD_DIR
    mkdir $BUILD_TMP_DIR
fi

PATH=$BUILD_DIR/bin:$PATH
LD_LIBRARY_PATH=$BUILD_DIR/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$BUILD_DIR/lib/pkgconfig:$PKG_CONFIG_PATH

# Build Ogg
if [ ! -d $BUILD_TMP_DIR/libogg-$OGG_VERS ]; then
    cd $BUILD_TMP_DIR
    tar xvf $THIRD_PARTY_DIR/libogg-$OGG_VERS.tar.gz
fi
if [ ! -f $BUILD_DIR/lib/libogg.a ]; then
    cd $BUILD_TMP_DIR/libogg-$OGG_VERS
    ./configure -C --prefix=$BUILD_DIR --enable-static
    make -j$PROCS
    make install
fi

#Build Vorbis
if [ ! -d $BUILD_TMP_DIR/libvorbis-$VORBIS_VERS ]; then
    cd $BUILD_TMP_DIR
    tar xvf $THIRD_PARTY_DIR/libvorbis-$VORBIS_VERS.tar.gz
fi
if [ ! -f $BUILD_DIR/lib/libvorbis.a ]; then
    cd $BUILD_TMP_DIR/libvorbis-$VORBIS_VERS
    ./configure -C --prefix=$BUILD_DIR  --with-ogg-libraries=$BUILD_DIR/lib --enable-static
    make -j$PROCS
    make install
fi

if [ ! -d $BUILD_TMP_DIR/opus-$OPUS_VERS ]; then
    cd $BUILD_TMP_DIR
    tar xvf $THIRD_PARTY_DIR/opus-$OPUS_VERS.tar.gz
fi
if [ ! -f $BUILD_DIR/lib/libopus.a ]; then
    cd opus-$OPUS_VERS
    ./configure -C --prefix=$BUILD_DIR --enable-static
    make -j$PROCS
    make install
fi

# Build libvpx
if [ ! -d $BUILD_TMP_DIR/libvpx-$VPX_VERS ]; then
    cd $BUILD_TMP_DIR
    tar xvf $THIRD_PARTY_DIR/libvpx-$VPX_VERS.tar.bz2
fi
if [ ! -f $BUILD_DIR/lib/libvpx.a ]; then
    cd $BUILD_TMP_DIR/libvpx-$VPX_VERS
    ./configure --prefix=$BUILD_DIR --enable-static
    make -j$PROCS
    make install
fi

#Build x264 source
if [ ! -d $BUILD_TMP_DIR/x264-snapshot-$X264_VERS-stable ]; then
    cd $BUILD_TMP_DIR
    tar xvf $THIRD_PARTY_DIR/x264-snapshot-$X264_VERS-stable.tar.bz2
fi
if [ ! -f $BUILD_DIR/lib/libx264.a ]; then
    cd $BUILD_TMP_DIR/x264-snapshot-$X264_VERS-stable
    ./configure --prefix=$BUILD_DIR --enable-static --disable-avs --disable-thread
    make -j$PROCS
    make install
fi

#Build faac
if [ ! -d $BUILD_TMP_DIR/faac-$FAAC_VERS ]; then
    cd $BUILD_TMP_DIR
    tar jxvf $THIRD_PARTY_DIR/faac-1.28.tar.bz2
fi
if [ ! -f $BUILD_DIR/lib/libfaac.a ]; then
    cd $BUILD_TMP_DIR/faac-$FAAC_VERS
    ./configure -C --prefix=$BUILD_DIR --without-mp4v2 --enable-static
    make -j$PROCS
    make install
fi

#Build lame
if [ ! -d $BUILD_TMP_DIR/lame-$LAME_VERS ]; then
    cd $BUILD_TMP_DIR
    tar xvf $THIRD_PARTY_DIR/lame-$LAME_VERS.tar.gz
fi
if [ ! -f $BUILD_DIR/lib/libmp3lame.a ]; then
    cd $BUILD_TMP_DIR/lame-$LAME_VERS
    ./configure -C --prefix=$BUILD_DIR --disable-frontend --disable-decoder --enable-static
    make -j$PROCS
    make install
fi

# Build SDL2
if [ ! -d $BUILD_TMP_DIR/SDL2-$SDL2_VERS ]; then
    cd $BUILD_TMP_DIR
    tar xvf $THIRD_PARTY_DIR/SDL2-$SDL2_VERS.tar.gz
fi
if [ ! -f $BUILD_DIR/lib/libSDL2.a ]; then
    cd $BUILD_TMP_DIR/SDL2-$SDL2_VERS
    ./configure -C --prefix=$BUILD_DIR --enable-video-mir=no --enable-static
    make -j$PROCS
    make install
fi

#Build ffmpeg
cd $BASE_DIR
if [ ! -d ffmpeg ]; then
    git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg
    cd ffmpeg
    git checkout $FFMPEG_VERS
    # Create base branch used to format patches in ffmpeg-patches
    # (e.g. git format-patch base)
    git checkout -b base 
    git checkout -b spatial-media
    git am ../ffmpeg-patches/*.patch
    cd $BASE_DIR
fi
cd ffmpeg
./configure --prefix=$BUILD_DIR --enable-static \
  --disable-ffserver \
  --enable-libx264 --enable-libmp3lame --enable-libvpx --enable-libvorbis --enable-libopus \
  --enable-gpl --enable-nonfree \
  --enable-opengl \
  --extra-cflags=-I$BUILD_DIR/include  \
  --extra-ldflags="-L$BUILD_DIR/lib -lpthread" \
  --extra-libs="$BUILD_DIR/lib/libfaac.a $BUILD_DIR/lib/libmp3lame.a $BUILD_DIR/lib/libx264.a $BUILD_DIR/lib/libopus.a"
make -j$PROCS
make install
cd $BASE_DIR
