ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

# ensure local pypy is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

ENV LANG C.UTF-8
ENV PYTHONIOENCODING=UTF-8
ENV GPG_KEY=44FE09DEE9E9EC21EF903F06CA614AB6BD73BB06

# Download the source
ARG PYPY_BASE=3.10
ARG PYPY_VERSION=7.3.13

RUN set -ex; \
    apk add --no-cache --virtual .fetch-deps \
        gnupg \
        tar \
        xz && \
    FILENAME="pypy${PYPY_BASE}-v${PYPY_VERSION}-linux-$(apk --print-arch)-alpine.tar.bz2" && \
    wget -O pypy.tar.bz2 "https://pypy.cyberjake.xyz/pypy/${PYPY_BASE}/${FILENAME}" && \
    wget -O pypy.tar.bz2.sig "https://pypy.cyberjake.xyz/pypy/${PYPY_BASE}/${FILENAME}.sig" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$GPG_KEY" && \
    gpg --batch --verify pypy.tar.bz2.sig pypy.tar.bz2 && \
    { command -v gpgconf > /dev/null && gpgconf --kill all || :; } && \
    rm -rf "$GNUPGHOME" pypy.tar.xz.sig && \
    \
    tar -xjC /usr/local --strip-components=1 -f pypy.tar.bz2 && \
    rm pypy.tar.bz2 && \
    apk del .fetch-deps && \
    \
    apk add --no-cache findutils && \
    find /usr/local -type f -executable -not \( -path '*tkinter*' \) -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ] || [ -e /usr/local/bin/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        | xargs -rt apk add --virtual .pypy-rundeps && \
    apk del findutils && \
    \
    pypy --version

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 20.3.4
ARG PIP_URL=https://bootstrap.pypa.io/get-pip.py
RUN set -ex; \
    \
    wget -O get-pip.py "${PIP_URL}" && \
    \
    pypy get-pip.py \
        --disable-pip-version-check \
        --no-cache-dir \
        "pip==$PYTHON_PIP_VERSION" setuptools wheel && \
    pip --version && \
    rm -f get-pip.py

CMD ["pypy"]