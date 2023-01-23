FROM cyb3rjak3/python-2.7.18:latest


# Add build dependencies
RUN apk add --update --no-cache --virtual .build-deps \
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
ENV PYPY_VERSION 7.3.11
ENV PYPY_SHA256SUM 1117afb66831da4ea6f39d8d2084787a74689fd0229de0be301f9ed9b255093c

RUN set -ex; \
    wget -O pypy.tar.bz2 "https://downloads.python.org/pypy/pypy2.7-v${PYPY_VERSION}-src.tar.bz2"; \
    echo "$PYPY_SHA256SUM *pypy.tar.bz2" | sha256sum -c -; \
    mkdir -p /usr/src/pypy; \
    tar -xjC /usr/src/pypy --strip-components=1 -f pypy.tar.bz2; \
    rm pypy.tar.bz2

WORKDIR /usr/src/pypy

COPY ./build.sh /build.sh
CMD ["/build.sh"]

VOLUME /tmp