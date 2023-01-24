ARG BUILD_IMAGE=cyb3rjak3/python-2.7.18:3.17
FROM ${BUILD_IMAGE}

ARG PYPY_BASE

# Add build dependencies
RUN apk add --no-cache --virtual .build-deps \
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
        pax-utils \
        readline-dev \
        sqlite-dev \
        tar \
        tk \
        tk-dev \
        xz-dev \
        zlib-dev

RUN pip install --no-cache-dir pycparser

# Download the source
ARG PYPY_VERSION=7.3.11
ARG PYPY_SHA256SUM=b0f3166fb2a5aadfd5ceb9db5cdd5f7929a0eccca02b4a26c0dae0492f7ca8ea

RUN set -ex; \
    wget -O pypy.tar.bz2 "https://downloads.python.org/pypy/pypy${PYPY_BASE}-v${PYPY_VERSION}-src.tar.bz2"; \
    echo "$PYPY_SHA256SUM *pypy.tar.bz2" | sha256sum -c -; \
    mkdir -p /usr/src/pypy; \
    tar -xjC /usr/src/pypy --strip-components=1 -f pypy.tar.bz2; \
    rm pypy.tar.bz2

WORKDIR /usr/src/pypy

COPY build.sh /build.sh
CMD ["/build.sh"]

VOLUME /tmp