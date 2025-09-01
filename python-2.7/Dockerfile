# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv
ARG ALPINE_VERSION=latest@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1
FROM alpine:${ALPINE_VERSION}

# Take from the last python 2.7 alpine image python:2.7.18-alpine
ENV PYTHONIOENCODING=UTF-8
ENV LANG=C.UTF-8
ENV PYTHON_VERSION=2.7.18

# This is my release key. The existing key used to sign python 2.7.18 doesn't load in gpg
# Still download the release from python so show it hasn't been tampered with
ENV GPG_KEY_ID=44FE09DEE9E9EC21EF903F06CA614AB6BD73BB06

RUN apk add --update --no-cache ca-certificates

RUN /bin/sh -c set -ex 	&& apk add --no-cache --virtual .fetch-deps \
        gnupg \
        tar \
        xz && \
    wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" && \
    wget -O python.tar.xz.asc "https://pypy.cyberjake.xyz/python/python-${PYTHON_VERSION%%[a-z]*}/python-$PYTHON_VERSION.tar.xz.sig" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --keyserver hkp://keys.openpgp.org:80 --recv-keys "$GPG_KEY_ID" && \
    gpg --batch --verify python.tar.xz.asc python.tar.xz && \
    { command -v gpgconf > /dev/null && gpgconf --kill all || :; }&& \
    rm -rf "$GNUPGHOME" python.tar.xz.asc && \
    mkdir -p /usr/src/python && \
    tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz && \
    rm python.tar.xz && \
    apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        coreutils \
        dpkg-dev \
        dpkg \
        expat-dev \
        findutils \
        gcc \
        gdbm-dev \
        libc-dev \
        libffi-dev \
        libnsl-dev 	\
        libtirpc-dev \
        linux-headers \
        make \
        ncurses-dev \
        openssl-dev \
        pax-utils \
        readline-dev \
        sqlite-dev \
        tcl-dev \
        tk \
        tk-dev \
        zlib-dev && \
    apk del .fetch-deps && \
    cd /usr/src/python && \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    ./configure --build="$gnuArch" --enable-optimizations --enable-option-checking=fatal --enable-shared --enable-unicode=ucs4 --with-system-expat --with-system-ffi && \
    make -j "$(nproc)" EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000" PROFILE_TASK='-m test.regrtest --pgo test_array test_base64 test_binascii test_binhex test_binop test_bytes test_c_locale_coercion test_class test_cmath test_codecs test_compile test_complex test_csv test_decimal test_dict test_float test_fstring test_hashlib test_io test_iter test_json test_long test_math test_memoryview test_pickle test_re test_set test_slice test_struct test_threading test_time test_traceback test_unicode' && \
    make install && \
    find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' | xargs -rt apk add --no-cache --virtual .python-rundeps && \
    apk del .build-deps && \
    find /usr/local -depth \( \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \) -exec rm -rf '{}' + && \
    rm -rf /usr/src/python && \
    python2 --version

ENV PYTHON_PIP_VERSION=20.0.2
ENV PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/d59197a3c169cef378a22428a3fa99d33e080a5d/get-pip.py
ENV PYTHON_GET_PIP_SHA256=421ac1d44c0cf9730a088e337867d974b91bdce4ea2636099275071878cc189e

RUN /bin/sh -c set -ex; \
    wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
    echo "$PYTHON_GET_PIP_SHA256 *get-pip.py" | sha256sum -c -; \
    python get-pip.py --disable-pip-version-check --no-cache-dir "pip==$PYTHON_PIP_VERSION" ; \
    pip --version; \
    find /usr/local -depth \( \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \) -exec rm -rf '{}' +; \
    rm -f get-pip.py

 CMD ["python2"]