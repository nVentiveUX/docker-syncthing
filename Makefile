# Copyright (c) 2017 nVentiveUX
# MIT
#
# Tasks for managing the project
#
.PHONY: default
default:
	@echo "Available targets:"
	@echo
	@echo "    build       Build the image and save result in build/ directory."
	@echo
	@echo "Done."

.PHONY: build
build: clean-build build-dir
	docker build --rm -t nventiveux/docker-syncthing:latest .
	docker save -o build/docker-syncthing_latest.tar nventiveux/docker-syncthing:latest
	gzip -9 build/docker-syncthing_latest.tar

.PHONY: clean-build
clean-build:
	rm -rf build/

.PHONY: build-dir
build-dir:
	mkdir -p build/
