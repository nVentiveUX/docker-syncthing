#!/bin/bash
#
# Easy to use installer script to setup latest stable release of Syncthing in a
# Docker container.
#
# Run it with:
#
#   curl -sSL https://raw.githubusercontent.com/nVentiveUX/docker-syncthing/master/installer.sh | sudo bash
#
set -euo pipefail
trap "echo 'ERROR: Script failed: see failed command above.'" ERR

SYNCTHING_IMAGE='nventiveux/docker-syncthing'
SYNCTHING_RELEASE='latest'

GITHUB_ROOT='https://raw.githubusercontent.com/nVentiveUX/docker-syncthing/master'

# Used for debugging with:
#   python3 -m http.server 8080
#GITHUB_ROOT='http://192.168.1.1:8080'

# Download a file using curl from remote repository
function repo_file_download() {
    local src="$1"
    local dest="$2"
    curl -sSL "${GITHUB_ROOT}/${src}" -o "${dest}"
}

# Install Docker Engine
function install_docker() {
    if [[ ! -x "$(which docker)" ]]; then
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
    repo_file_download \
        "systemd/docker-syncthing@.service" \
        "/etc/systemd/system/docker-syncthing@.service"
    repo_file_download \
        "systemd/docker-syncthing.service" \
        "/etc/systemd/system/docker-syncthing.service"

    if [[ ! -e "/etc/default/docker-syncthing" ]]; then
        repo_file_download \
            "systemd/docker-syncthing@.default" \
            "/etc/default/docker-syncthing"
    fi

    systemctl daemon-reload

    echo "### Enabling docker-syncthing at system boot..."
    systemctl enable docker-syncthing.service
}

function start_syncthing_service() {
    echo "## Starting docker-syncthing service..."
    systemctl start docker-syncthing.service
}

function configure() {
    echo
    echo "IMPORTANT NOTICE:"
    echo "   You may now want to provide content to syncthing, please edit /etc/default/docker-syncthing to configure volumes."
    echo "   Then, restart the service with \"sudo systemctl restart docker-syncthing\" to apply changes."
    echo
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
configure
start_syncthing_service
show_success

exit 0
