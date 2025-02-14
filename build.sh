#!/bin/bash

set -e

timestamp() {
    date -u +'%Y-%m-%dT%H:%M:%SZ'
}

REPO=ghcr.io/educelab/ci-docker
VER_MAJOR=12
VER_MINOR=1
VER_PATCH=1
VER_EXTRA=
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

for TYPE in base dynamic static; do
  echo ========== Building ${TYPE} image  ==========
  docker buildx build \
    -f Dockerfile.${TYPE} \
    --platform linux/amd64,linux/arm64 \
    --build-arg CI_DOCKER_VERSION=${VER_FULL} \
    --provenance false \
    $(labels) \
    $(tags ${TYPE}) \
    --push \
    .
done