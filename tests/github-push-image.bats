#!/usr/bin/env bats

# Place the following before an assertion to debug the output
# echo "output = ${output}"

@test "valid master tagging" {
    export GITHUB_REF=refs/heads/master
    export IMAGE_TAG=12345678
    run docker tag busybox libero/my-dummy-project:12345678
    run github/push-image.sh my-dummy-project
    [ "$status" -eq 0 ]
    run docker pull ${DOCKER_REGISTRY}liberoadmin/my-dummy-project:12345678
    [ "$status" -eq 0 ]
    run docker pull ${DOCKER_REGISTRY}liberoadmin/my-dummy-project:latest
    [ "$status" -eq 0 ]
}
