Volume Cartographer Debian Docker Builder
=========================================

This repository contains the Dockerfile to build the volcart/debian
Docker image. This image contains all prerequisite libraries required
to build and test the
[volume-cartographer](https://code.vis.uky.edu/seales-research/volume-cartographer)
project. Most of the build is handled by [vc-deps](https://code.vis.uky.edu/seales-research/vc-deps)
so that consistency can be maintained across platforms.

Requirements
------------
 * Docker 1.10.x or higher

Building
--------
```shell
git clone https://code.vis.uky.edu/seales-research/docker-debian-builder.git
cd docker-debian-build
git submodule init
git submodule update
./build.sh
```
