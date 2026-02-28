#!/bin/bash

set -eu

next_version="$(git cliff --bumped-version)"

# Checks
if [[ -n $(git status --porcelain) ]]
then
  echo "Repo is dirty. Commit all changes first !"
  exit 1
fi

# Prepare new changelog
git cliff --bump --output CHANGELOG.md
git add CHANGELOG.md
git commit -m "chore(release): prepare for ${next_version}"
