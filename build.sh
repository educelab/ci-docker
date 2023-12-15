#!/bin/bash

set -e

timestamp() {
    date -u +'%Y-%m-%dT%H:%M:%SZ'
}

REPO=ghcr.io/educelab/ci-docker
MAJOR=12
MINOR=0
PATCH=0
SUFFIX=
VERSION_FULL=${MAJOR}.${MINOR}.${PATCH}${SUFFIX}
REV=$(git rev-parse --verify HEAD)

labels() {
    echo --label org.opencontainers.image.created=$(timestamp) \
    --label org.opencontainers.image.licenses=AGPL-3.0 \
    --label org.opencontainers.image.revision=${REV} \
    --label org.opencontainers.image.url=https://github.com/educelab/ci-docker \
    --label org.opencontainers.image.version=${VERSION_FULL}
}

tags() {
  TYPE=$1
  TAGS="--tag ${REPO}:${TYPE}.${VERSION_FULL} \
        --tag ${REPO}:${TYPE}.${MAJOR}.${MINOR}"
  if [[ $TYPE == 'static' ]]; then
    TAGS="${TAGS} --tag ${REPO}:latest --tag ${REPO}:${VERSION_FULL} --tag ${REPO}:${MAJOR}.${MINOR}"
  fi
  echo "${TAGS}"
}

echo ========== Building base image  ==========
docker buildx build --platform linux/amd64,linux/arm64 --push $(labels) $(tags base) -f Dockerfile.base .
echo ========== Building dynamic image  ==========
docker buildx build --platform linux/amd64,linux/arm64 --push $(labels) $(tags dynamic) -f Dockerfile.dynamic .
echo ========== Building static image  ==========
docker buildx build --platform linux/amd64,linux/arm64 --push $(labels) $(tags static) -f Dockerfile.static .
echo ========== Done  ==========