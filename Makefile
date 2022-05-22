SHELL = /bin/bash
ARCH = amd64 arm32v6

# Tasks
#
.PHONY: dockerfiles
dockerfiles: install $(ARCH)

.PHONY: install
install: .venv

.PHONY: tests
tests:
	docker run -it --rm --name syncthing_tests nventiveux/syncthing:develop

.PHONY: clean
clean:
	docker image rm nventiveux/syncthing:develop

# Files
#
.venv:
	@mkdir -v "$@"
	@pipenv install --dev

$(ARCH):
	ARCH=$@ pipenv run j2 Dockerfile.j2 > Dockerfile.$@
