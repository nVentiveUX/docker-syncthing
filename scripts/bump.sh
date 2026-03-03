#!/bin/bash

set -eu

next_version="$(git cliff --bumped-version)"

# Checks
if [[ -n $(git status --porcelain) ]]
then
  echo "Repo is dirty. Commit all changes first !"
  exit 1
fi

# Bump files
sed -i -r -e "s/(Image version:.+)\`[0-9]+\.[0-9]+\.[0-9]+\`/\1\`${next_version:1}\`/" README.md

# Prepare new changelog
git cliff --bump --output CHANGELOG.md
git add CHANGELOG.md README.md
git commit -m "chore(release): prepare for ${next_version}"
