#!/usr/bin/env bats

# Place the following before an assertion to the the output
# echo "output = ${output}"

docker pull busybox > /dev/null

teardown () {
    unset GITHUB_SHA
    unset GITHUB_REF
}


@test "valid other branch" {
    export GITHUB_REF=refs/heads/foobar
    export GITHUB_SHA=1234567890ab
    run docker tag busybox libero/otherbranch:123
    run github/retag-and-push.sh otherbranch 123
    [ "$status" -eq 0 ]
    docker images | grep -P "${DOCKER_REGISTRY}liberoadmin/otherbranch\s*foobar-12345678-\d{8}\.\d{4}\s"
    [ "$status" -eq 0 ]
    docker images | grep -P "${DOCKER_REGISTRY}liberoadmin/otherbranch\s*foobar-12345678\s"
    [ "$status" -eq 0 ]
    run docker pull ${DOCKER_REGISTRY}liberoadmin/otherbranch:latest
    [ "$status" -eq 1 ]
}

@test "valid master tagging" {
    export GITHUB_REF=refs/heads/master
    export GITHUB_SHA=1234567890ab
    run docker tag busybox libero/my-dummy-project:123
    run github/retag-and-push.sh my-dummy-project 123
    [ "$status" -eq 0 ]
    docker images | grep -P "${DOCKER_REGISTRY}liberoadmin/my-dummy-project\s*master-12345678-\d{8}\.\d{4}"
    [ "$status" -eq 0 ]
    run docker pull ${DOCKER_REGISTRY}liberoadmin/my-dummy-project:latest
    [ "$status" -eq 0 ]
}

@test "rename liberoadmin to libero" {
    export GITHUB_REF=refs/tags/v1.2.43
    export GITHUB_SHA=1234567809ab
    run docker tag busybox liberoadmin/my-dummy-project:123
    run github/retag-and-push.sh my-dummy-project 123
    [ "$status" -eq 0 ]
    run docker pull ${DOCKER_REGISTRY}liberoadmin/my-dummy-project:1
    [ "$status" -eq 0 ]
    run docker pull ${DOCKER_REGISTRY}liberoadmin/my-dummy-project:latest
    [ "$status" -eq 0 ]
}

@test "valid semver tagging" {
    export GITHUB_REF=refs/tags/v1.2.43
    export GITHUB_SHA=1234567890ab
    run docker tag busybox libero/my-dummy-project:master-12345678
    run github/retag-and-push.sh my-dummy-project 12345678
    [ "$status" -eq 0 ]
    run docker pull ${DOCKER_REGISTRY}liberoadmin/my-dummy-project:1
    [ "$status" -eq 0 ]
    run docker pull ${DOCKER_REGISTRY}liberoadmin/my-dummy-project:1.2
    [ "$status" -eq 0 ]
    run docker pull ${DOCKER_REGISTRY}liberoadmin/my-dummy-project:1.2.43
    [ "$status" -eq 0 ]
}

@test "missing v in tag" {
    export GITHUB_REF=refs/tags/1.2.43
    export GITHUB_SHA=1234567890ab
    run docker tag busybox libero/my-dummy-project:master-12345678
    run github/retag-and-push.sh my-dummy-project 12345678
    [ "$status" -eq 1 ]
    [ "${lines[-2]}" = "refs/tags/1.2.43 is neither a branch head or valid semver tag" ]
    [ "${lines[-1]}" = "No image tagging or pushing was performed because of this." ]
}

@test "invalid semver" {
    export GITHUB_REF=refs/tags/01.2.43
    export GITHUB_SHA=1234567890ab
    run docker tag busybox libero/my-dummy-project:master-12345678
    run github/retag-and-push.sh my-dummy-project 12345678
    [ "$status" -eq 1 ]
    [ "${lines[-2]}" = "refs/tags/01.2.43 is neither a branch head or valid semver tag" ]
}
