# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is not an application codebase — it builds and releases a single Docker image, `nventiveux/syncthing`, which wraps the upstream [Syncthing](https://syncthing.net/) binary for amd64/arm32v6/armv7/arm64. The "code" is the [Dockerfile](Dockerfile), an entrypoint script, and a set of release-automation scripts.

## Commands

Toolchain (`task`, `git-cliff`) is pinned via `asdf` in [.tool-versions](.tool-versions); run `asdf install` once before using `task`.

- `task tests` — build the image and run it locally for manual testing. Requires `DOCKER_TAG` (e.g. `task tests DOCKER_TAG=latest`); there is no automated test suite.
- `task clean` — remove the local `nventiveux/syncthing:latest` image.
- `task preview-changelog` — preview the changelog that `git cliff --bump --unreleased` would generate, without writing anything.
- `task bump:syncthing` — bump to the latest upstream Syncthing release ([scripts/bump-syncthing.sh](scripts/bump-syncthing.sh)): fetches the latest tag from the GitHub API, updates `SYNCTHING_VERSION` in the Dockerfile and the version table in the README, and commits.
- `task bump` — bump this project's own version ([scripts/bump.sh](scripts/bump.sh)): computes the next version via `git-cliff`, updates the README's "Image version" line, regenerates [CHANGELOG.md](CHANGELOG.md), and commits.
- `task tag` — tag a release via `git-cliff` ([scripts/tag.sh](scripts/tag.sh)); push tags manually afterwards (`git push origin --tags`).

All three `scripts/*.sh` bump/tag scripts refuse to run on a dirty working tree.

Dockerfile linting (hadolint) and multi-arch image builds/pushes run in CI ([.github/workflows/ci.yaml](.github/workflows/ci.yaml), [.github/workflows/cd.yaml](.github/workflows/cd.yaml)), not via `task`. [.hadolint.yaml](.hadolint.yaml) intentionally ignores `DL3018` (Alpine package pinning).

## Release flow

1. `git switch -c release/next`
2. `task bump:syncthing` → open PR → CI builds/tests the image
3. Merge, then `task bump` → merge that too
4. `git switch main && git pull && task tag && git push origin --tags`
5. Pushing a `v*.*.*` tag triggers CD: multi-arch build/push to Docker Hub via [docker-bake.hcl](docker-bake.hcl), plus a GitHub release with the git-cliff-generated changelog.

**Important**: when bumping the Syncthing version, also sync the config file's schema `version` attribute in [rootfs/etc/syncthing/config.xml](rootfs/etc/syncthing/config.xml) against upstream's [`lib/config/config.go`](https://github.com/syncthing/syncthing/blob/main/lib/config/config.go#L36) — this is a manual step, not automated by `bump-syncthing.sh`.

## Commit convention

Conventional Commits, enforced by changelog generation ([cliff.toml](cliff.toml)):
- `feat`, `fix`, `doc`, `perf`, `refactor`, `style`, `test` each map to a changelog section.
- `chore` and `bump` commits are excluded from the changelog entirely (used for release/bump commits themselves).
- Scope `(syncthing)` (e.g. `feat(syncthing): bump to 2.1.1`) is special-cased into an "⬆️ Upstream" changelog group regardless of its `feat`/`fix` prefix.

## Runtime architecture

[Dockerfile](Dockerfile): Alpine base, downloads and verifies (sha256) the upstream Syncthing release tarball for `SYNCTHING_ARCH`, copies [rootfs/](rootfs/) over the image root, declares `/etc/syncthing` and `/var/lib/syncthing` as volumes.

[rootfs/docker-entrypoint.sh](rootfs/docker-entrypoint.sh) runs on every container start, before `exec`-ing into Syncthing as an unprivileged user:
1. bcrypt-hashes `SYNCTHING_ADMIN_PASSWORD` (default `admin`) via `python3`/`py3-bcrypt`.
2. Creates or updates the `SYNCTHING_USER`/`SYNCTHING_GROUP` (with `SYNCTHING_USER_UID`/`SYNCTHING_GROUP_GID`) so the container can run as a host-matching UID/GID.
3. `chown`s `/etc/syncthing` and `/var/lib/syncthing` to that user/group if ownership drifted.
4. Rewrites `<user>`/`<password>` in [rootfs/etc/syncthing/config.xml](rootfs/etc/syncthing/config.xml) via `sed` to the configured admin credentials.
5. `exec su-exec syncthing "$@"` — drops privileges and hands off to the actual `syncthing` process (the Dockerfile's `CMD`).

Configuration is entirely environment-variable-driven (`SYNCTHING_USER`, `SYNCTHING_USER_UID`, `SYNCTHING_GROUP`, `SYNCTHING_GROUP_GID`, `SYNCTHING_ADMIN_USER`, `SYNCTHING_ADMIN_PASSWORD`) — see [README.md](README.md) for the full table and an example `docker run` invocation.
