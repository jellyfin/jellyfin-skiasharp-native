FROM alpine:3.8 as gn-builder

ARG GN_COMMIT=377ad0417d8f7df348fd865e21a0a905daa4b22c

RUN \
  apk add --update --virtual .gn-build-dependencies \
    alpine-sdk \
    binutils-gold \
    clang \
    curl \
    git \
    llvm4 \
    ninja \
    python \
    tar \
    xz \
  # Two quick fixes: we need the LLVM tooling in $PATH, and we
  # also have to use gold instead of ld.
  && PATH=$PATH:/usr/lib/llvm4/bin \
  && cp -f /usr/bin/ld.gold /usr/bin/ld \

  # Clone and build gn
  && git clone https://gn.googlesource.com/gn /tmp/gn \
  && git -C /tmp/gn checkout ${GN_COMMIT} \
  && cd /tmp/gn \
  && python build/gen.py \
  && ninja -C out \
  && cp -f /tmp/gn/out/gn /usr/local/bin/gn \

  # Remove build dependencies and temporary files
  && apk del .gn-build-dependencies \
  && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*


FROM alpine:3.8

COPY --from=gn-builder /usr/local/bin/gn /build/buildtools/linux64/gn

RUN apk add --update alpine-sdk git ninja clang clang-dev python2 bash fontconfig-dev #libwebp-dev libpng-dev freetype-dev libjpeg-turbo-dev zlib-dev expat-dev

WORKDIR /build
COPY compile-libSkiaSharp.sh compile-libSkiaSharp.sh

RUN chmod +x compile-libSkiaSharp.sh \
	&& bash compile-libSkiaSharp.sh 2>&1