#!/bin/bash

set -e

timestamp() {
    date -u +'%Y-%m-%dT%H:%M:%SZ'
}

REPO=ghcr.io/educelab/ci-docker
VER_MAJOR=12
VER_MINOR=1
VER_PATCH=0
VER_FULL=${VER_MAJOR}.${VER_MINOR}.${VER_PATCH}
REV=$(git rev-parse --verify HEAD)

labels() {
    echo --label org.opencontainers.image.created=$(timestamp) \
    --label org.opencontainers.image.licenses=AGPL-3.0 \
    --label org.opencontainers.image.revision=${REV} \
    --label org.opencontainers.image.url=https://github.com/educelab/ci-docker \
    --label org.opencontainers.image.version=${VER_FULL}
}

tags() {
  TYPE=$1
  TAGS="--tag ${REPO}:${TYPE}.${VER_FULL} \
        --tag ${REPO}:${TYPE}.${VER_MAJOR}.${VER_MINOR} \
        --tag ${REPO}:${TYPE}.latest"
  if [[ $TYPE == 'static' ]]; then
    TAGS="${TAGS} --tag ${REPO}:latest --tag ${REPO}:${VER_FULL} --tag ${REPO}:${VER_MAJOR}.${VER_MINOR}"
  fi
  echo "${TAGS}"
}

echo ========== Building base image  ==========
docker buildx build --platform linux/amd64,linux/arm64 --provenance false --push $(labels) $(tags base) -f Dockerfile.base .
echo ========== Building dynamic image  ==========
docker buildx build --platform linux/amd64,linux/arm64 --provenance false --push $(labels) $(tags dynamic) -f Dockerfile.dynamic .
echo ========== Building static image  ==========
docker buildx build --platform linux/amd64,linux/arm64 --provenance false --push $(labels) $(tags static) -f Dockerfile.static .
echo ========== Done  ==========