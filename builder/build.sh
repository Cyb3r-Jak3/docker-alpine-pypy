#!/usr/bin/env sh
set -ex

isSet() {
    [ -z "${1}" ]
}

if isSet "${PYPY_BASE}"; then
    echo "Missing ${PYPY_BASE}"
    exit 1
fi

if isSet "${PYPY_VERSION}"; then
    echo "Missing ${PYPY_VERSION}"
    exit 1
fi

if isSet "${PYPY_SHA256SUM}"; then
    echo "Missing ${PYPY_SHA256SUM}"
    exit 1
fi


wget -O pypy.tar.bz2 "https://downloads.python.org/pypy/pypy${PYPY_BASE}-v${PYPY_VERSION}-src.tar.bz2"
echo "${PYPY_SHA256SUM} *pypy.tar.bz2" | sha256sum -c -
mkdir -p /usr/src/pypy
tar -xjC /usr/src/pypy --strip-components=1 -f pypy.tar.bz2
rm pypy.tar.bz2

BASE_DIR="/usr/src/pypy"
PYTHON="$(which pypy || which python)"

PYPY_NAME="pypy${PYPY_BASE}"
PYPY_RELEASE_VERSION="${PYPY_RELEASE_VERSION:-$PYPY_VERSION}"
PYPY_ARCH="linux$(apk --print-arch)-alpine"

# set thread stack size to 1MB so we don't segfault before we hit sys.getrecursionlimit()
# https://github.com/alpinelinux/aports/commit/2026e1259422d4e0cf92391ca2d3844356c649d0
export CFLAGS="-DTHREAD_STACK_SIZE=0x100000 $CFLAGS"

# Translation
cd "$BASE_DIR"/pypy/goal
"$PYTHON" ../../rpython/bin/rpython --opt=jit

# Packaging
cd "$BASE_DIR"/pypy/tool/release
"$PYTHON" package.py --archive-name "$PYPY_NAME-v$PYPY_RELEASE_VERSION-$PYPY_ARCH"