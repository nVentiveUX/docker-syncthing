SHELL = /bin/bash

# Tasks
#
.PHONY: install
install: .venv

.PHONY: tests
tests:
	docker run -it --rm --name syncthing_tests local/syncthing:latest

.PHONY: clean
clean:
	docker image rm local/syncthing:latest

# Files
#
.venv:
	@mkdir -v "$@"
	@pipenv install --dev
