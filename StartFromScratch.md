# Starting from Scratch

If you want to start this project from scratch for yourself then you can follow this guide. You will need to need to change the tags located in [docker-bake.hcl](./docker-bake.hcl). Read more about buildx bake [here](https://docs.docker.com/engine/reference/commandline/buildx_bake/). All of these images are designed to support amd64 and arm64 architecture but you can change the `platform` list to only select one. If you are running on GitHub actions then you need to use a more powerful runner for building with bootstrap images because they will timeout. For all of the `bake` commands you need to either use `--load` if you are using a single platform or `--push` if multiple platforms.

## Building

Prerequisite:

- Docker with [buildx](https://docs.docker.com/engine/reference/commandline/buildx/) setup
- You need a python 2.7 image to use for bootstrap image. You can use the docker file from [python-2.7](./python-2.7/) to get started. However, it relies on my signature file so it might break if the file gets lost.
- You need checksum for PyPy source files. I have an API that lists them as JSON [here](https://api.cyberjake.xyz/pypy/checksums/all), [Read More](https://github.com/Cyb3r-Jak3/workers-serverless-api). You can also get the checksums from [PyPy](https://www.pypy.org/checksums.html).

### 1. Bootstrap Builder Image

The first image you need is the bootstrap image. This image builds pypy using python which is slower and you can not run this on GitHub Actions. The first version that you want to build is 2.7 because you can then build the rest of PyPy using it.

Command: `docker buildx bake alpine-pypy-builder-bootstrap` then you can run `docker run --platform <platform> -v $(pwd)/tmp:/tmp -e PYPY_BASE=2.7 -e PYPY_VERSION=7.3.11 -e PYPY_SHA256SUM=<checksum> <docker image tag>` and wait for it to compile. The bootstrap can take a few hours depending on the power of your computer.

## 2. Non-bootstrap Builder Image

Once you have build pypy-2.7 then you can create an export image for it which allows you to build PyPy a lot faster.

Command: `docker buildx bake alpine-pypy-2_7`

## 3. Building PyPy with Non-bootstrap

The next step is to build the builder image that use the `alpine-pypy:2.7-v<PYPY_BASE>` image.
Command: `docker buildx bake alpine-pypy-builder` then you can run `docker run --platform <platform> -v $(pwd)/tmp:/tmp -e PYPY_BASE=2.7 -e PYPY_VERSION=7.3.11 -e PYPY_SHA256SUM=<checksum> <docker image tag>` and wait for it to compile. It should take a lot less time than bootstrap.

## Using with GitHub actions

This project uses [GitHub Actions](https://docs.github.com/en/actions) to provider reliable, repeatable and public builds. All the docker images and PyPy artifacts are built here. Most things can run on the `ubuntu-latest` runner but if you are attempting to build PyPy for ARM64 then you will need an external runner because the builds will timeout. As of writing this Oracle offers a free tier that includes an arm VM [Read More](https://www.oracle.com/cloud/free/). This is used to build arm64 images for this project.

### Adding New Architecture

If you want to add a new architecture to this process you do the following:

1. Edit [docker-bake.hcl](./docker-bake.hcl) and under the python image add the new platform. Then run `docker buildx bake python-2_7 --push`

2. Then you can build the bootstrap image with `docker build --platform=<platform> -t <bootstrap image tag> --build-arg BUILD_IMAGE=<python image tag> .\builder\`

3. Then you can build PyPy with `docker run -v ${PWD}/tmp:/tmp --platform <platform> -it -e PYPY_BASE=2.7 -e PYPY_VERSION=7.3.11 -e PYPY_SHA256SUM=1117afb66831da4ea6f39d8d2084787a74689fd0229de0be301f9ed9b255093c <bootstrap image tag>`

You will then have PyPy which you can upload and use to make an image with the PyPy.
