#!/bin/bash
set -e

function finish() {
    docker stop registry
}

trap finish EXIT

docker run --detach --publish 5000:5000 --rm --name registry registry:2

docker pull busybox
docker tag busybox libero/my-dummy-project:12345678
GITHUB_REF=refs/head/master \
DOCKER_REGISTRY=localhost:5000/ \
DOCKER_USERNAME=foo \
DOCKER_PASSWORD=bar \
IMAGE_TAG=12345678 \
github/push-image.sh my-dummy-project
