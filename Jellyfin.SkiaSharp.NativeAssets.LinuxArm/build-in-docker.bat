docker build -t libskiasharp-linuxarm .
mkdir runtimes/linux-arm/native
mkdir runtimes/linux-arm64/native
docker run --rm -v "%CD%/runtimes/linux-arm/native:/temp" "libskiasharp-linuxarm" cp /build/skia/out/linux-arm/libSkiaSharp.so /temp/
docker run --rm -v "%CD%/runtimes/linux-arm64/native:/temp64" "libskiasharp-linuxarm" cp /build/skia/out/linux-arm64/libSkiaSharp.so /temp64/