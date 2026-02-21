#!/bin/bash

set -eu

next_version="${1:?Usage: $0 <next_version>}"

# Checks
if [[ -n $(git status --porcelain) ]]
then
  echo "Repo is dirty. Commit all changes first !"
  exit 1
fi

git cliff --bump "${next_version}" --unreleased --strip header | git tag --cleanup=verbatim -a "${next_version}" -F -
