#!/bin/bash
#
# Easy to use installer script to setup latest stable release of Syncthing in a
# Docker container.
#
set -euo pipefail
trap "echo 'ERROR: Script failed: see failed command above.'" ERR

SYNCTHING_IMAGE='nventiveux/docker-syncthing'
SYNCTHING_RELEASE='0.14.18'

# Install Docker Engine
function install_docker() {
    if [[ -x docker ]]; then
        echo "## Docker is not found. Installing..."
        ( curl -sSL https://get.docker.com/ | sh )
    fi
}

function pull_image() {
    echo "## Pulling image \"${SYNCTHING_IMAGE}\"..."
    docker pull ${SYNCTHING_IMAGE}:${SYNCTHING_RELEASE}
}

function install_systemd_service() {
    echo "## Installing systemd service..."
    cp -v systemd/docker-syncthing.service /etc/systemd/system/ &&
    cp -v systemd/docker-syncthing@.default /etc/default/docker-syncthing &&
    systemctl daemon-reload &&

    echo "### Enabling docker-syncthing at system boot..."
    systemctl enable docker-syncthing.service;
}

function start_syncthing_service() {
    echo "## Starting docker-syncthing service..."
    systemctl start docker-syncthing.service
}

function configure() {
    echo
    echo "IMPORTANT NOTICE:"
    echo "   You may now want to provide content to syncthing, please edit /etc/default/docker-syncthing to add volumes."
    echo "   Then, restart the service with \"sudo systemctl restart docker-syncthing\" to apply changes."
    echo
    /etc/default/docker-syncthing
}

function show_success() {
    echo
    echo "Done. Installation successfull."
    echo "Make your browser point to https://localhost:8384/ to configure your syncthing installation."
}

# Main
install_docker
pull_image
install_systemd_service
start_syncthing_service
configure
show_success

exit 0
