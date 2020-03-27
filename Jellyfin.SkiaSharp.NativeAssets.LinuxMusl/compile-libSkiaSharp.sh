#!/bin/bash


set -e
if [ ! -d "skia" ] ; then
    git clone https://github.com/mono/skia.git -b v1.68.1 --depth 1 skia
fi

cd skia

python tools/git-sync-deps

/build/buildtools/linux64/gn gen 'out/linux-musl-x64' --args='
    is_official_build=true skia_enable_tools=false
    target_os="linux" target_cpu="x64"    
    skia_use_icu=false skia_use_sfntly=false skia_use_piex=true
    skia_use_system_expat=false skia_use_system_freetype2=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=false
    skia_enable_gpu=true
    extra_cflags=[ "-DSKIA_C_DLL", "-O3" ]
    linux_soname_version=""'

# compile
ninja 'SkiaSharp' -C 'out/linux-musl-x64'

cd ..
