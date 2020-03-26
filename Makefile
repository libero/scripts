BATS := "node_modules/bats/bin/bats"

setup: install-deps launch_registry

install-deps:
	npm install
	docker pull busybox

launch_registry:
	docker run --detach --publish 5000:5000 --rm --name registry registry:2

teardown:
	docker stop registry

test: test-static test-image_push

test-static:
	bash -xc "shellcheck */*.sh"
	bash -xc "find */ -name '*.sh' | xargs -I {} test -x {}"

test-image_push:
	DOCKER_REGISTRY=localhost:5000/ \
	DOCKER_USERNAME=foo \
	DOCKER_PASSWORD=bar \
	$(BATS) -r tests/
