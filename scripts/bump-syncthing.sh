#!/bin/bash

set -eu

# Checks
if [[ -n $(git status --porcelain) ]]
then
  echo "Repo is dirty. Commit all changes first !"
  exit 1
fi

# get latest stable version for syncthing
next_version="$(curl -fsSL "https://api.github.com/repos/syncthing/syncthing/releases/latest" | jq -r '.tag_name | ltrimstr("v")')"
echo "Fetched latest stable version: ${next_version}"

# Bump all versions
sed -i -r -e "s/SYNCTHING_VERSION=\".*\"/SYNCTHING_VERSION=\"${next_version}\"/" Dockerfile
sed -i -r -e "s/(Syncthing version:.+)\`v[0-9]+\.[0-9]+\.[0-9]+\`/\1\`v${next_version}\`/" README.md

# Prepare commit
git add Dockerfile README.md
git commit -m "feat(syncthing): bump to ${next_version}

* [Release notes](https://github.com/syncthing/syncthing/releases/tag/v${next_version})"
