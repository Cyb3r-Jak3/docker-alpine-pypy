# Docker Alpine PyPy

This project provides [PyPy](https://www.pypy.org/) docker images built on top of [alpine](https://www.alpinelinux.org/). These images are based off of [JayH5/docker-alpine-pypy](https://github.com/JayH5/docker-alpine-pypy) and [JayH5/alpine-pypy](https://github.com/JayH5/alpine-pypy) but using later version of pypy and alpine.

## Docker Images

There are 4 images that are created as a part of this project. Image are available from both DockerHub and GitHub container registry.

DockerHub prefix: `cyb3rjak3/`
GitHub prefix: `ghcr.io/cyb3r-jak3/`

### Export Image

The main image, found in [export](./export/), is an alpine image with PyPy. The image tag format for this image is `alpine-pypy:$PYPY_VERSION-$ALPINE_VERSION`

### Builder Images

The images that are used to build PyPy can be found in [builder](./builder/). The image tag format for this image is `alpine-pypy-builder:$PYPY_VERSION-$BOOTSTRAP-$ALPINE_VERSION`

Where:

- `$PYPY_VERSION`: Version of PyPy used. Tag in the form of `{2.7,3.9}-$VERSION` (e.g. `3.9-7.3.11`).

- `$ALPINE_VERSION`: Version of Alpine used (e.g. `3.17`).

- `$BOOTSTRAP`: If image is using Python then `bootstrap` is added otherwise it does not exist.

### Python 2.7.18 Image

In order to get the bootstrap image, Python 2.7 is need. There is a single tag for this image: `python-2.7.18:3.17` which is python 2.7.18 on alpine 3.17. **This image should only be used for building PyPy**

## PyPy Downloads

The built PyPy code is available for download as well. All builds are signed by my release key `44FE09DEE9E9EC21EF903F06CA614AB6BD73BB06`. Download use the following format

PyPy:

`https://pypy.cyberjake.xyz/pypy/$PYPY_BASE/$FILENAME`

GPG Signature:

`https://pypy.cyberjake.xyz/pypy/$PYPY_BASE/$FILENAME.sig`

Where:

- `$PYPY_BASE`: Version of base pypy (e.g. `2.7`, `3.9`)
- `$FILENAME`: Built filename (e.g. `pypy3.9-v7.3.11-linux-x86_64-alpine.tar.bz2`)

Example:

PyPy: 3.9-7.3.11 and Alpine: 3.17 generate a link of `https://pypy.cyberjake.xyz/pypy/3.9/pypy3.9-v7.3.11-linux-x86_64-alpine.tar.bz2` for PyPy download and `https://pypy.cyberjake.xyz/pypy/3.9/pypy3.9-v7.3.11-linux64-alpine.tar.bz2.sig` for signature download.

### Available Versions

| PyPy Base | PyPy Version | Alpine Version |  Arch  |
|-----------|--------------|----------------|--------|
| 3.9       | 7.3.11       | 3.17           | x86_64 |
| 3.8       | 7.3.11       | 3.17           | x86_64 |
| 2.7       | 7.3.11       | 3.17           | x86_64 |

Please make an issue if you want to see a specific version.
