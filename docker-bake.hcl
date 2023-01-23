// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
    platforms = [
        "linux/amd64",
        "linux/arm/v6",
        "linux/arm/v7",
        "linux/arm64",
        "linux/386",
    ]
}

target "alpine-pypy" {
    dockerfile = "./export/Dockerfile"
    tags = [
        "cyb3rjak3/alpine-pypy:3.9-7.3.11-3.17",
        "ghcr.io/cyb3r-jak3/alpine-pypy:3.9-7.3.11-3.17"
    ]
}


target "python-2_7" {
    dockerfile = "./python-2.7/Dockerfile"
    tags = [
        "cyb3rjak3/python-2.7.18:3.17",
        "ghcr.io/cyb3r-jak3/python-2.7.18:3.17"
    ]
}

target "alpine-pypy-release" {
    inherits = ["docker-metadata-action", "alpine-pypy"]
}

target "python-2_7-release" {
    inherits = ["docker-metadata-action", "python-2_7"]
}