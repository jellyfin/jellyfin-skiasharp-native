# SkiaSharp Native library for arm32 and arm64.

The 64-bit build runs with `-flax-vector-conversions` so, use at your own risk. Upstream issue: https://skia-review.googlesource.com/c/skia/+/84222 GCC seems to not support this.

## Build (Debian based) (Also WSL)

1. `cross-compile-libSkiaSharp.sh`
2. `mkdir -p ./runtimes/linux-arm/native && mkdir -p ./runtimes/linux-arm64/native`
3. `cp skia/out/linux-arm/libSkiaSharp.so ./runtimes/linux-arm/native/ && cp skia/out/linux-arm64/libSkiaSharp.so ./runtimes/linux-arm64/native/`
4. `nuget pack`

## Build (non Debian) (uses docker)

1. `build-in-docker.sh`
2. `nuget pack`