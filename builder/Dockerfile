ARG BUILD_IMAGE=cyb3rjak3/python-2.7.18:3.17
FROM ${BUILD_IMAGE}

# ARG PYPY_BASE
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

WORKDIR /usr/src/pypy

COPY build.sh /build.sh

RUN chmod +x /build.sh

CMD ["/build.sh"]

VOLUME /tmp