SHELL = /bin/bash

# Tasks
#
.PHONY: install
install:
	@rye sync

.PHONY: build
build:
	docker build -t local/syncthing:latest .

.PHONY: tests
tests:
	docker run -it --rm --name syncthing_tests local/syncthing:latest

.PHONY: clean
clean:
	docker image rm local/syncthing:latest

.PHONY: release
release: version=""
release:
	@{ [[ -z "${version}" ]] || exit 0; } && { echo "Missing syncthing version !"; exit 1; }
	sed -i -r -e "s/SYNCTHING_VERSION=\".*\"/SYNCTHING_VERSION=\"${version}\"/" Dockerfile
	sed -i -r -e "s/\`v[0-9]+\.[0-9]+\.[0-9]+\`/\`v${version}\`/" README.md
