#!/bin/bash

docker build -t libskiasharp-musllinux .
mkdir -p ./runtimes/linux-musl-x64/native
docker run --rm -v "./runtimes/linux-musl-x64/native:/temp" "libskiasharp-musllinux" cp /build/skia/out/linux-musl-x64/libSkiaSharp.so /temp/