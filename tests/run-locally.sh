#!/bin/bash
set -e

function finish() {
    docker stop registry
}

trap finish EXIT

docker run --detach --publish 5000:5000 --rm --name registry registry:2

DOCKER_REGISTRY=localhost:5000/ \
DOCKER_USERNAME=foo \
DOCKER_PASSWORD=bar \
bats tests/github-retag-and-push.bats
