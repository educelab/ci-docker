#!/bin/bash

set -e

timestamp() {
    date -u +'%Y-%m-%dT%H:%M:%SZ'
}

REPO=ghcr.io/educelab/ci-docker
VER_MAJOR=12
VER_MINOR=1
VER_PATCH=1
VER_EXTRA="-dev3"
VER_FULL=${VER_MAJOR}.${VER_MINOR}.${VER_PATCH}${VER_EXTRA}
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
  TAGS="--tag ${REPO}:${TYPE}.${VER_FULL}"
  if [[ -z "$VER_EXTRA" ]]; then
    TAGS="${TAGS} \
          --tag ${REPO}:${TYPE}.${VER_MAJOR}.${VER_MINOR} \
          --tag ${REPO}:${TYPE}.latest"
    if [[ $TYPE == 'static' ]]; then
      TAGS="${TAGS} --tag ${REPO}:latest --tag ${REPO}:${VER_FULL} --tag ${REPO}:${VER_MAJOR}.${VER_MINOR}"
    fi
  fi
  echo "${TAGS}"
}

echo ========== Building base image  ==========
docker buildx build --target base --platform linux/amd64,linux/arm64 --provenance false --push $(labels) $(tags base) -f Dockerfile .
echo ========== Building dynamic image  ==========
docker buildx build --target dynamic --platform linux/amd64,linux/arm64 --provenance false --push $(labels) $(tags dynamic) -f Dockerfile .
echo ========== Building static image  ==========
docker buildx build --target static --platform linux/amd64,linux/arm64 --provenance false --push $(labels) $(tags static) -f Dockerfile .
echo ========== Done  ==========