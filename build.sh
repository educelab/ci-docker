#!/bin/bash

REPO=ghcr.io/educelab/ci-docker
VERSION=11_v2

docker buildx build --platform linux/amd64,linux/arm64 --push -t ${REPO}:${VERSION}.base -f Dockerfile.base . && \
docker buildx build --platform linux/amd64,linux/arm64 --push -t ${REPO}:${VERSION}.dynamic -f Dockerfile.dynamic . && \
docker buildx build --platform linux/amd64,linux/arm64 --push -t ${REPO}:latest -t ${REPO}:${VERSION}.static -f Dockerfile.static .

# Extra tags
docker buildx build --platform linux/amd64 --push -t ${REPO}:${VERSION}.base.amd64 -f Dockerfile.base . && \
docker buildx build --platform linux/arm64 --push -t ${REPO}:${VERSION}.base.arm64 -f Dockerfile.base . && \
docker buildx build --platform linux/amd64 --push -t ${REPO}:${VERSION}.static.amd64 -f Dockerfile.static . && \
docker buildx build --platform linux/arm64 --push -t ${REPO}:${VERSION}.static.arm64 -f Dockerfile.static . && \
docker buildx build --platform linux/amd64 --push -t ${REPO}:${VERSION}.dynamic.amd64 -f Dockerfile.dynamic . && \
docker buildx build --platform linux/arm64 --push -t ${REPO}:${VERSION}.dynamic.arm64 -f Dockerfile.dynamic .
