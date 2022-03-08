# Volume Cartographer Debian Docker Builder

This repository contains the Dockerfile to build the `volcart/vcbuilder-debian`
[Docker image](https://hub.docker.com/repository/docker/volcart/vcbuilder-debian). This image contains all prerequisite libraries required
to build and test the
[volume-cartographer](https://gitlab.com/educelab/volume-cartographer)
project. Most of the build is handled by
[vc-deps](https://gitlab.com/educelab/vc-deps) so that consistency can be
maintained across platforms.

## Requirements
 * Docker 4.5+

## Building
```shell
git clone --recursive https://code.vis.uky.edu/seales-research/docker-debian-builder.git
cd docker-debian-builder
./build.sh
```

## Updating the version
1. Change `VERSION` in [build.sh](build.sh)
2. Update the base image version in the `FROM` command for each of the `Dockerfile.[static|dynamic]` files
