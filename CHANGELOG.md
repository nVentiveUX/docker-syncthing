<!-- markdownlint-disable MD024 -->

# Changelog

All notable changes to this project will be documented in this file.

## 3.2.0 - 2026-06-09

### <!-- 0 -->⬆️ Upstream

* **syncthing**: Bump to 2.1.1

  * [Release notes](https://github.com/syncthing/syncthing/releases/tag/v2.1.1)

### <!-- 1 -->🚀 Features

* **config**: Bump config version schema to 52

### <!-- 2 -->🐛 Bug Fixes

* **tests**: Allow to select image tag in `tests` task

## 3.1.0 - 2026-03-03

### <!-- 0 -->⬆️ Upstream

* **syncthing**: Bump to 2.0.15

  * [Release notes](https://github.com/syncthing/syncthing/releases/tag/v2.0.15)

### <!-- 1 -->🚀 Features

* **scripts**: Fetch latest release from github api for syncthing

### <!-- 2 -->🐛 Bug Fixes

* **readme**: Incorrect image tags in README after a bump

## 3.0.0 - 2026-02-28

### <!-- 0 -->⬆️ Upstream

* **syncthing**: Bump to 2.0.14

  * <https://github.com/syncthing/syncthing/releases/tag/v2.0.14>

### <!-- 1 -->🚀 Features

* **core**: Has its own lifecycle from now

  The project's version is not anymore related to syncthing own lifecyle. Check CHANGELOG to know which version of syncthing is embeded in the image.
* **core**: Harmonize project release
* **core**: Bump syncthing to 2.0.13
* **image**: Update base image to alpine:3.23 and improve bump scripts

### <!-- 2 -->🐛 Bug Fixes

* **release**: Incorrect tag version in tag task

## 2.0.11 - 2025-11-30

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 2.0.11

## 2.0.10 - 2025-10-23

### <!-- 1 -->🚀 Features


### <!-- 2 -->🐛 Bug Fixes

* **ci**: Login to docker hub in pr

## 1.30.0 - 2025-07-15

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.30.0

## 1.29.6 - 2025-05-07

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.29.6

## 1.29.2 - 2025-02-18

### <!-- 1 -->🚀 Features

* **core**: Bump alpine to 3.21
* **core**: Bump syncthing to 1.29.2

### <!-- 2 -->🐛 Bug Fixes

* **docker**: Removed signature check for sha256sum.txt.asc

## 1.28.1 - 2024-12-05

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.28.1

## 1.27.12 - 2024-09-07

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.27.12

### <!-- 2 -->🐛 Bug Fixes

* **ci**: Manual release for the moment
* **ci**: Trigger on master

## 1.27.9 - 2024-07-04

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.27.9

## 1.27.6 - 2024-04-11

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.27.6

    See [official release](https://github.com/syncthing/syncthing/releases/tag/v1.27.6).

## 1.27.5 - 2024-04-07

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.27.5

    See [official release](https://github.com/syncthing/syncthing/releases/tag/v1.27.5).

## 1.27.4 - 2024-03-24

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.27.4

    See [official release](https://github.com/syncthing/syncthing/releases/tag/v1.27.4).
* **dev**: Move from `poetry` to `rye`

## 1.27.2 - 2024-01-04

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.27.2

    See [official release](https://github.com/syncthing/syncthing/releases/tag/v1.27.2).

## 1.26.1 - 2023-11-24

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.26.1

    See [official release](https://github.com/syncthing/syncthing/releases/tag/v1.26.1).

## 1.25.0 - 2023-10-05

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.25.0

    See [official release](https://github.com/syncthing/syncthing/releases/tag/v1.25.0).

## 1.24.0 - 2023-09-24

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.24.0

## 1.23.7 - 2023-08-22

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.23.7

## 1.23.5 - 2023-06-11

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.23.5

## 1.23.4 - 2023-04-10

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to 1.23.4

## 1.23.2 - 2023-03-10

### <!-- 1 -->🚀 Features

* **core**: Bump syncthing to v1.23.2

## 1.23.1 - 2023-02-10

### <!-- 1 -->🚀 Features

* **ci**: Auto create a release for tags
* **core**: Bump syncthing to v1.23.1

## 1.23.0 - 2023-02-03

### <!-- 1 -->🚀 Features


### <!-- 3 -->📚 Documentation


## 1.22.2 - 2022-12-07

### <!-- 1 -->🚀 Features

* **ci**: Add post releases in image tags
* **core**: Bump syncthing to 1.22.2
* **release**: Add a changelog
* **release**: Move to `commitizen`

## 1.22.1-0 - 2022-11-27

### <!-- 1 -->🚀 Features

* **ci**: Switch to multiarch images

## 1.20.1-0 - 2022-05-22

### <!-- 1 -->🚀 Features


## 1.19.1-0 - 2022-03-04

### <!-- 1 -->🚀 Features

* **config**: Update schema to v36

### <!-- 7 -->🧪 Testing


## 1.18.5-0 - 2021-12-07

### <!-- 1 -->🚀 Features


## 1.17.0-1 - 2021-06-30

### <!-- 1 -->🚀 Features

* **ci**: Migrate to github actions

### <!-- 2 -->🐛 Bug Fixes

* **ci**: Missing source image in docker tag
* **ci**: Image_tag ➞ image-tag
* **ci**: Wrong quote in if expression
* **ci**: Sks pgp keyservers are gone
* **ci**: Update new gpg syncthing release keys

## 1.15.1-0 - 2021-04-06

### Config


## 1.9.0-0 - 2020-09-10

### Config


## 1.7.1-0 - 2020-07-14

### Config


### Project


### Readme


## 1.5.0-2 - 2020-05-10

### Entrypoint


## 1.4.1-0 - 2020-04-06

### Config


## 1.3.1-0 - 2019-11-05

### <!-- 1 -->🚀 Features

* **ci**: Script to push images
* **ci**: Use scripts to build images

### <!-- 2 -->🐛 Bug Fixes

* **ci**: Search for QEMU_VERSION in environment
* **ci**: Invalid detecttion for ARCH

## 1.3.0-0 - 2019-10-06

### <!-- 2 -->🐛 Bug Fixes

* **bumpversion**: Bump all Dockerfiles

## 1.2.1-0 - 2019-08-06

### <!-- 1 -->🚀 Features

* **core**: Upgrade syncthing to v1.2.1

## 1.2.0-0 - 2019-07-13

### <!-- 0 -->⬆️ Upstream

* **syncthing**: Disable relaying by default
* **syncthing**: Disable global announce by default

### <!-- 1 -->🚀 Features

* **Dockerfiles**: Templates used for Dockerfiles
* **README**: Add build status
* **README**: Refresh and refactor README
* **ci**: Tag image using git tags for versioning
* **ci**: Use travis to build / push images
* **init**: Allow to specify user UID/GID

### <!-- 2 -->🐛 Bug Fixes

* **ci**: Refresh secure tokens
* **config**: Local announces are disabled by default
* **rootfs**: Rootfs is root of filesystem

## 0.1.0 - 2017-01-05
