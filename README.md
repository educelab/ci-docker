# EduceLab Docker CI Configuration

This repository contains the Dockerfile to build the `ghcr.io/educelab/ci-docker`
[Docker image](https://github.com/orgs/educelab/packages/container/package/ci-docker). This image contains all prerequisite libraries required
to build and test the
[volume-cartographer](https://github.com/educelab/volume-cartographer)
project. Most of the build is handled by
[vc-deps](https://github.com/educelab/vc-deps) so that consistency can be
maintained across platforms.

## Requirements
 * Docker engine 19.03+

## Building
```shell
git clone --recursive https://github.com/educelab/ci-docker
cd ci-docker
docker buildx create --use
./build.sh
```

## Updating the version
Change the version components in [build.sh](build.sh). Values should match the rules 
for [semantic versioning](https://semver.org/):

```bash
# build.sh
VER_MAJOR=12
VER_MINOR=0
VER_PATCH=0
```
