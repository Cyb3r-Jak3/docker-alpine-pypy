// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
    platforms = [
        "linux/amd64",
        "linux/arm64"
    ]
}

variable "PYPY_VERSION" {
    default = "7.3.17"
}

variable "ALPINE_VERSION" {
    default = "3.20"
}

target "alpine-pypy-2_7" {
    context = "./export"
    args = {
        PIP_URL = "https://bootstrap.pypa.io/pip/2.7/get-pip.py"
        PYPY_BASE = "2.7"
        PYPY_VERSION = "${PYPY_VERSION}"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }

    tags = [
        "cyb3rjak3/alpine-pypy:2.7-${PYPY_VERSION}-${ALPINE_VERSION}",
        "ghcr.io/cyb3r-jak3/alpine-pypy:2.7-${PYPY_VERSION}-${ALPINE_VERSION}"
    ]
    
}

target "alpine-pypy-3_9" {
    context = "./export"
    args =  {
        PYPY_BASE = "3.9"
        PYPY_VERSION = "7.3.16"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
    
    tags = [
        "cyb3rjak3/alpine-pypy:3.9-7.3.16-${ALPINE_VERSION}",
        "ghcr.io/cyb3r-jak3/alpine-pypy:3.9-7.3.16-${ALPINE_VERSION}"
    ]
}

target "alpine-pypy-3_10" {
    context = "./export"
    args = {
        PYPY_BASE = "3.10"
        PYPY_VERSION = "${PYPY_VERSION}"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }

    tags = [
        "cyb3rjak3/alpine-pypy:3.10-${PYPY_VERSION}-${ALPINE_VERSION}",
        "ghcr.io/cyb3r-jak3/alpine-pypy:3.10-${PYPY_VERSION}-${ALPINE_VERSION}"
    ]
}

target "alpine-pypy-builder" {
    context = "./builder"
    args = {
        BUILD_IMAGE = "ghcr.io/cyb3r-jak3/alpine-pypy:2.7-7.3.12-3.17"
    }

    tags = [
        "cyb3rjak3/alpine-pypy-builder:3.17",
        "ghcr.io/cyb3r-jak3/alpine-pypy-builder:3.17"
    ]
}

target "alpine-pypy-builder-bootstrap" {
    context = "./builder"

    tags = [
        "cyb3rjak3/alpine-pypy-builder:3.17-bootstrap",
        "ghcr.io/cyb3r-jak3/alpine-pypy-builder:3.17-bootstrap"
    ]
    platforms = [
        "linux/amd64",
        "linux/arm64",
        // "linux/386"
    ]
}

target "python-2_7" {
    context = "python-2.7"
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
    tags = [
        "cyb3rjak3/python-2.7.18:${ALPINE_VERSION}",
        "ghcr.io/cyb3r-jak3/python-2.7.18:${ALPINE_VERSION}"
    ]
    platforms = [
        "linux/amd64",
        "linux/arm64",
        // "linux/riscv64"
    ]
}

target "alpine-pypy-2_7-release" {
    inherits = ["docker-metadata-action", "alpine-pypy-2_7"]
}


target "alpine-pypy-3_9-release" {
    inherits = ["docker-metadata-action", "alpine-pypy-3_9"]
}

target "alpine-pypy-3_10-release" {
    inherits = ["docker-metadata-action", "alpine-pypy-3_10"]
}

target "alpine-pypy-builder-release" {
    inherits = ["docker-metadata-action", "alpine-pypy-builder", ]
}

target "alpine-pypy-builder-bootstrap-release" {
    inherits = ["docker-metadata-action", "alpine-pypy-builder-bootstrap"]
}

target "python-2_7-release" {
    inherits = ["docker-metadata-action", "python-2_7"]
}