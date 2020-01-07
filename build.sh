#!/bin/bash

REPO=volcart/vcbuilder-debian
VERSION=9_v9

docker build -t ${REPO}:${VERSION}.base -f Dockerfile.base . && \
docker build -t ${REPO}:${VERSION}.static -f Dockerfile.static . && \
docker build -t ${REPO}:${VERSION}.dynamic -f Dockerfile.dynamic . && \
docker build -t ${REPO}:${VERSION}.experimental -f Dockerfile.experimental .
