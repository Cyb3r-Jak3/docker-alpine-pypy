# Use bootstrap image by default
ARG BUILD_IMAGE=ghcr.io/cyb3r-jak3/python-2.7.18:3.22@sha256:48b239b8bc9ffe1e5d7ae2f14d0cc138b94f12c0e03dd534911e5293201ba671
FROM ${BUILD_IMAGE}

# Add build dependencies
RUN --mount=type=cache,target=/var/cache/apk,sharing=locked apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        expat-dev \
        gcc \
        gdbm-dev \
        libc-dev \
        libffi-dev \
        linux-headers \
        make \
        ncurses-dev \
        openssl-dev \
        patch \
        pax-utils \
        readline-dev \
        sqlite-dev \
        tar \
        tk \
        tk-dev \
        xz-dev \
        zlib-dev

RUN --mount=type=cache,target=/root/.cache/pip pip install --disable-pip-version-check pycparser
COPY patches/ /tmp/patches/

WORKDIR /usr/src/pypy

COPY build.sh /build.sh

RUN chmod +x /build.sh

CMD ["/build.sh"]

VOLUME /tmp