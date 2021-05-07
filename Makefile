SHELL = /bin/bash
ARCH = amd64 arm32v6

# Tasks
#
.PHONY: dockerfiles
dockerfiles: install $(ARCH)

.PHONY: install
install: .venv

# Files
#
.venv:
	@[[ -d .venv ]] || mkdir .venv
	@pipenv install --dev

$(ARCH):
	ARCH=$@ pipenv run j2 Dockerfile.j2 > Dockerfile.$@
