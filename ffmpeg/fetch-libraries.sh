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

# Fetch rav1e
if [ ! -f rav1e-$RAV1E_VERS.tar.gz ]; then
    wget -O rav1e-$RAV1E_VERS.tar.gz https://github.com/xiph/rav1e/archive/v$RAV1E_VERS.tar.gz
fi

# Fetch libvpx
if [ ! -f libvpx-$VPX_VERS.tar.gz ]; then
    wget -O libvpx-$VPX_VERS.tar.gz https://chromium.googlesource.com/webm/libvpx/+archive/v$VPX_VERS.tar.gz
fi

# Fetch faac
if [ ! -f faac-$FAAC_VERS.tar.gz ]; then
    wget -O faac-$FAAC_VERS.tar.gz https://github.com/knik0/faac/archive/$FAAC_VERS.tar.gz
fi

# Fetch lame
if [ ! -f  lame-$LAME_VERS.tar.gz ]; then
    wget -O lame-$LAME_VERS.tar.gz http://sourceforge.net/projects/lame/files/lame/$LAME_VERS/lame-$LAME_VERS.tar.gz/download
fi

# Fetch SDL2
if [ ! -f SDL2-$SDL2_VERS.tar.gz ]; then
    wget https://www.libsdl.org/release/SDL2-$SDL2_VERS.tar.gz
fi
