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
sed -i -r -e "s/(Image version:.+)\`v[0-9]+\.[0-9]+\.[0-9]+\`/\1\`v${next_version}\`/" README.md

# Prepare new changelog
git cliff --bump --output CHANGELOG.md
git add CHANGELOG.md
git commit -m "chore(release): prepare for ${next_version}"
