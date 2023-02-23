#!/bin/bash

REPO=volcart/vcbuilder-debian
VERSION=11_v2

docker buildx build --platform linux/amd64,linux/arm64 --push -t ${REPO}:${VERSION}.base -f Dockerfile.base . && \
docker buildx build --platform linux/amd64,linux/arm64 --push -t ${REPO}:${VERSION}.static -f Dockerfile.static . && \
docker buildx build --platform linux/amd64,linux/arm64 --push -t ${REPO}:${VERSION}.dynamic -f Dockerfile.dynamic .
