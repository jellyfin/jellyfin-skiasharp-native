#!/bin/bash

TOOLCHAIN_ARM64=gcc-linaro-4.9.4-2017.01-x86_64_aarch64-linux-gnu

set -e
if [ ! -d "skia" ] ; then
    git clone https://github.com/mono/skia.git -b v1.68.0 --depth 1 skia
fi
if [ ! -d "depot_tools" ] ; then
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git --depth 1
fi
if [ ! -d "tools" ] ; then
    git clone https://github.com/raspberrypi/tools.git --depth 1
fi
if [ ! -d "${TOOLCHAIN_ARM64}" ] ; then
    wget -O linaro_aarch64.tar.xz "https://releases.linaro.org/components/toolchain/binaries/latest-4/aarch64-linux-gnu/${TOOLCHAIN_ARM64}.tar.xz"
    tar -xJvf linaro_aarch64.tar.xz
fi
if [ ! -d "libfontconfig1-arm32" ] ; then
    mkdir -p libfontconfig1-arm32

    pushd libfontconfig1-arm32
    wget -O libfontconfig1_armhf.deb http://archive.raspbian.org/raspbian/pool/main/f/fontconfig/libfontconfig1_2.11.0-6.7_armhf.deb
    ar vx libfontconfig1_armhf.deb
    tar -xJvf data.tar.xz
     
    wget -O libfontconfig1-dev_armhf.deb http://archive.raspbian.org/raspbian/pool/main/f/fontconfig/libfontconfig1-dev_2.11.0-6.7_armhf.deb
    ar vx libfontconfig1-dev_armhf.deb
    tar -xJvf data.tar.xz

    cp -R ./usr/lib/arm-linux-gnueabihf/* ../tools/arm-bcm2708/arm-linux-gnueabihf/arm-linux-gnueabihf/lib
    cp -R usr/include/fontconfig ../tools/arm-bcm2708/arm-linux-gnueabihf/arm-linux-gnueabihf/include/
     
    popd
fi
if [ ! -d "libfontconfig1-arm64" ] ; then
    mkdir -p libfontconfig1-arm64

    pushd libfontconfig1-arm64
    wget -O libfontconfig1_arm64.deb http://ftp.nl.debian.org/debian/pool/main/f/fontconfig/libfontconfig1_2.11.0-6.7+b1_arm64.deb
    ar vx libfontconfig1_arm64.deb
    tar -xJvf data.tar.xz
     
    wget -O libfontconfig1-dev_arm64.deb http://ftp.nl.debian.org/debian/pool/main/f/fontconfig/libfontconfig1-dev_2.11.0-6.7+b1_arm64.deb
    ar vx libfontconfig1-dev_arm64.deb
    tar -xJvf data.tar.xz

    cp -R ./usr/lib/aarch64-linux-gnu/* "../${TOOLCHAIN_ARM64}/aarch64-linux-gnu/lib"
    cp -R usr/include/fontconfig "../${TOOLCHAIN_ARM64}/aarch64-linux-gnu/include/"
     
    popd
fi

OLDPATH=$PATH

export PATH="$PATH:`pwd`/tools/arm-bcm2708/arm-linux-gnueabihf/bin"

pushd skia

python tools/git-sync-deps

./bin/gn gen 'out/linux-arm' --args='
    cc = "arm-linux-gnueabihf-gcc"
    cxx = "arm-linux-gnueabihf-g++"
    is_official_build=true skia_enable_tools=false
    target_os="linux" target_cpu="arm"
    skia_use_icu=false skia_use_sfntly=false skia_use_piex=true
    skia_use_system_expat=false skia_use_system_freetype2=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=false
    skia_enable_gpu=true
    extra_cflags=[ "-DSKIA_C_DLL" ]
    linux_soname_version=""'

# compile
../depot_tools/ninja 'SkiaSharp' -C 'out/linux-arm'

popd
export PATH="$OLDPATH:`pwd`/${TOOLCHAIN_ARM64}/bin"

# Patch source if not already patched
if ! patch -R -p0 -s -f --dry-run <patches/aarch64-skia-build-fix.patch; then
   patch -p0 -b <patches/aarch64-skia-build-fix.patch
fi
# Debian: apt install libjpeg62-turbo  libexpat1 libfreetype6 libpng16-16 libwebp6 zlib1g
pushd skia

./bin/gn gen 'out/linux-arm64' --args='    
    cc = "aarch64-linux-gnu-gcc"
    cxx = "aarch64-linux-gnu-g++"
    is_official_build=true skia_enable_tools=false
    target_os="linux" target_cpu="arm64"
    skia_use_icu=false skia_use_sfntly=false skia_use_piex=true
    skia_use_system_expat=false skia_use_system_freetype2=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=false
    skia_enable_gpu=true
    extra_cflags=[ "-DSKIA_C_DLL", "-flax-vector-conversions" ]
    linux_soname_version=""'
   
# compile
../depot_tools/ninja 'SkiaSharp' -C 'out/linux-arm64'

popd
