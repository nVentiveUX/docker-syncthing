#!/bin/bash

set -eu

next_version="${1:?Usage: $0 <next_version>}"

# Checks
if [[ -n $(git status --porcelain) ]]
then
  echo "Repo is dirty. Commit all changes first !"
  exit 1
fi

# Bump all versions
sed -i -r -e "s/SYNCTHING_VERSION=\".*\"/SYNCTHING_VERSION=\"${next_version}\"/" Dockerfile
sed -i -r -e "s/v[0-9]+\.[0-9]+\.[0-9]+/v${next_version}/" README.md

# Prepare commit
git add Dockerfile README.md
git commit -m "feat(syncthing): bump to ${next_version}

* [Release notes](https://github.com/syncthing/syncthing/releases/tag/v${next_version})"
