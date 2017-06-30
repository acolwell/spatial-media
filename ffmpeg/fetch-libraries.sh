#!/bin/bash

set -e -x

BASE_DIR=$PWD
THIRD_PARTY_DIR=$BASE_DIR/third_party
PROCS=8

source "library-versions.inc"

if [ ! -d $THIRD_PARTY_DIR ]; then
    mkdir $THIRD_PARTY_DIR
fi


cd $THIRD_PARTY_DIR

# Fetch Ogg
if [ ! -f libogg-$OGG_VERS.tar.gz ]; then
    wget http://downloads.xiph.org/releases/ogg/libogg-$OGG_VERS.tar.gz
fi

# Fetch Vorbis
if [ ! -f libvorbis-$VORBIS_VERS.tar.gz ]; then
    wget http://downloads.xiph.org/releases/vorbis/libvorbis-$VORBIS_VERS.tar.gz
fi

# Fetch Opus
if [ ! -f opus-$OPUS_VERS.tar.gz ]; then
    wget http://downloads.xiph.org/releases/opus/opus-$OPUS_VERS.tar.gz
fi

# Fetch libvpx
if [ ! -f libvpx-$VPX_VERS.tar.bz2 ]; then
    wget http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-$VPX_VERS.tar.bz2
fi

# Fetch x264
if [ ! -f x264-snapshot-$X264_VERS-stable.tar.bz2 ]; then
    wget ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-$X264_VERS-stable.tar.bz2
fi

# Fetch faac
if [ ! -f faac-$FAAC_VERS.tar.bz2 ]; then
    wget http://downloads.sourceforge.net/faac/faac-$FAAC_VERS.tar.bz2
fi

# Fetch lame
if [ ! -f  lame-$LAME_VERS.tar.gz ]; then
    wget -O lame-$LAME_VERS.tar.gz http://sourceforge.net/projects/lame/files/lame/3.99/lame-$LAME_VERS.tar.gz/download
fi

# Fetch SDL2
if [ ! -f SDL2-$SDL2_VERS.tar.gz ]; then
    wget https://www.libsdl.org/release/SDL2-$SDL2_VERS.tar.gz
fi
