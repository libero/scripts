BATS := "node_modules/bats/bin/bats"

setup: install-deps launch-registry

install-deps:
	npm install bats@1.x
	docker pull busybox

launch-registry:
	docker run --detach --publish 5000:5000 --rm --name registry registry:2

teardown:
	docker stop registry

test: test-static test-image-push

test-static:
	bash -xc "shellcheck */*.sh"
	bash -xc "find */ -name '*.sh' | xargs -I {} test -x {}"

test-image-push:
	DOCKER_REGISTRY=localhost:5000/ \
	DOCKER_USERNAME=foo \
	DOCKER_PASSWORD=bar \
	$(BATS) -r tests/
