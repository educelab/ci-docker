#!/bin/bash

REPO=volcart/vcbuilder-debian
VERSION=11_v1

docker build -t ${REPO}:${VERSION}.base -f Dockerfile.base . && \
docker build -t ${REPO}:${VERSION}.static -f Dockerfile.static . && \
docker build -t ${REPO}:${VERSION}.dynamic -f Dockerfile.dynamic .
