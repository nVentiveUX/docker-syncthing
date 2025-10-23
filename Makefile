SHELL = /bin/bash

# Tasks
#
.PHONY: venv
venv:
	@uv sync

.PHONY: build
build:
	docker build -t local/syncthing:latest .

.PHONY: tests
tests: build
	docker run -it --rm -p 8000:8384 --name syncthing_tests local/syncthing:latest

.PHONY: clean
clean:
	docker image rm local/syncthing:latest

.PHONY: release
release: version=""
release:
	@{ [[ -z "${version}" ]] || exit 0; } && { echo "Missing syncthing version !"; exit 1; }
	sed -i -r -e "s/SYNCTHING_VERSION=\".*\"/SYNCTHING_VERSION=\"${version}\"/" Dockerfile
	sed -i -r -e "s/\`v[0-9]+\.[0-9]+\.[0-9]+\`/\`v${version}\`/" README.md
