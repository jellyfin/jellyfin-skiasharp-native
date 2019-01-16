FROM debian:9

RUN apt-get update \
   && apt-get install -y --no-install-recommends wget xz-utils git binutils python ca-certificates patch

WORKDIR /build
COPY patches/ patches/
COPY cross-compile-libSkiaSharp.sh cross-compile-libSkiaSharp.sh

RUN chmod +x cross-compile-libSkiaSharp.sh \
	&& bash cross-compile-libSkiaSharp.sh 2>&1