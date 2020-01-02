#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
    echo "Pushes a local container image to Docker Hub"
    echo 
    echo "Usage: $0 PROJECT"
    echo "Example: $0 dummy-api"
    echo "Relies on the following environment variables:"
    echo "- GITHUB_REF"
    echo "- DOCKER_USERNAME, DOCKER_PASSWORD"
    echo "- IMAGE_TAG"
    exit 1
fi

DOCKER_REGISTRY="${DOCKER_REGISTRY:-}"
project="$1"

if [[ "$GITHUB_REF" = "refs/heads/master" ]]; then
    echo "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin "${DOCKER_REGISTRY}"

    # tag temporarily as liberoadmin due to lack of `libero/` availability
    docker tag "libero/$project:$IMAGE_TAG" "${DOCKER_REGISTRY}liberoadmin/$project:$IMAGE_TAG"
    docker push "${DOCKER_REGISTRY}liberoadmin/$project:$IMAGE_TAG"
    # push `latest` image
    docker tag "libero/$project:$IMAGE_TAG" "${DOCKER_REGISTRY}liberoadmin/$project:latest"
    docker push "${DOCKER_REGISTRY}liberoadmin/$project:latest"
else
    echo "not pushing an image, we are not on master"
fi
