#!/bin/bash

REPO=volcart/vcbuilder-debian
VERSION=10_v1

docker build -t ${REPO}:${VERSION}.base -f Dockerfile.base . && \
docker build -t ${REPO}:${VERSION}.static -f Dockerfile.static . && \
docker build -t ${REPO}:${VERSION}.dynamic -f Dockerfile.dynamic . && \
docker build -t ${REPO}:${VERSION}.experimental -f Dockerfile.experimental .
