// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
    platforms = [
        "linux/amd64",
        "linux/arm64",
    ]
}

target "alpine-pypy-3" {
    context = "./export"
    tags = [
        "cyb3rjak3/alpine-pypy:3.9-7.3.11-3.17",
        "ghcr.io/cyb3r-jak3/alpine-pypy:3.9-7.3.11-3.17"
    ]
}

target "alpine-pypy-2" {
    context = "./export"
    args = {
        PIP_URL = "https://bootstrap.pypa.io/pip/2.7/get-pip.py"
        PYPY_BASE = "2.7"
    }
    tags = [
        "cyb3rjak3/alpine-pypy:2.7-7.3.11-3.17",
        "ghcr.io/cyb3r-jak3/alpine-pypy:2.7-7.3.11-3.17"
    ]
}

target "alpine-pypy-builder-3_9" {
    context = "./builder"
    args = {
        PYPY_BASE = "3.9"
        BUILD_IMAGE = "cyb3rjak3/alpine-pypy:2.7-7.3.11-3.17"
    }

    tags = [
        "cyb3rjak3/alpine-pypy-builder:3.9-7.3.11-3.17",
        "ghcr.io/cyb3r-jak3/alpine-pypy-builder:3.9-7.3.11-3.17"
    ]
}

target "alpine-pypy-builder-3_9-bootstrap" {
    context = "./builder"
    args = {
        PYPY_BASE = "3.9"
    }
    tags = [
        "cyb3rjak3/alpine-pypy-builder:3.9-7.3.11-bootstrap-3.17",
        "ghcr.io/cyb3r-jak3/alpine-pypy-builder:3.9-7.3.11-bootstrap-3.17"
    ]
}

target "python-2_7" {
    context = "python-2.7"
    tags = [
        "cyb3rjak3/python-2.7.18:3.17",
        "ghcr.io/cyb3r-jak3/python-2.7.18:3.17"
    ]
    platforms = [
        "linux/amd64",
        "linux/arm/v6",
        "linux/arm/v7",
        "linux/arm64",
    ]
}

target "alpine-pypy-release" {
    inherits = ["docker-metadata-action", "alpine-pypy2", "alpine-pypy3"]
    platforms = ["amd64"]
}

target "alpine-pypy-builder-release" {
    inherits = ["docker-metadata-action", "alpine-pypy-builder-3_9", "alpine-pypy-builder-3_9-bootstrap"]
    platforms = ["amd64"]
}

target "python-2_7-release" {
    inherits = ["docker-metadata-action", "python-2_7"]
}