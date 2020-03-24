#!/bin/bash
set -e

function finish() {
    docker stop registry
}

trap finish EXIT

docker run --detach --publish 5000:5000 --rm --name registry registry:2

docker pull busybox

# valid input
docker tag busybox libero/my-dummy-project:12345678
GITHUB_REF=refs/heads/master \
GITHUB_SHA=12345678 \
DOCKER_REGISTRY=localhost:5000/ \
DOCKER_USERNAME=foo \
DOCKER_PASSWORD=bar \
github/retag-and-push.sh my-dummy-project 12345678

# non-master branch
GITHUB_REF=refs/heads/foobar \
GITHUB_SHA=12345678 \
DOCKER_REGISTRY=localhost:5000/ \
DOCKER_USERNAME=foo \
DOCKER_PASSWORD=bar \
github/retag-and-push.sh my-dummy-project 12345678

# valid semver
docker tag busybox libero/my-dummy-project:master-12345678
GITHUB_REF=refs/tags/v1.2.43 \
GITHUB_SHA=12345678 \
DOCKER_REGISTRY=localhost:5000/ \
DOCKER_USERNAME=foo \
DOCKER_PASSWORD=bar \
github/retag-and-push.sh my-dummy-project master-12345678