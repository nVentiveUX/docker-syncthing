# Syncthing Docker image

[![Build Status](https://travis-ci.org/nVentiveUX/docker-syncthing.svg?branch=master)](https://travis-ci.org/nVentiveUX/docker-syncthing)

Syncthing Docker image for RaspberryPi / amd64 systems.

> Syncthing replaces proprietary sync and cloud services with something open, trustworthy and decentralized.

See [Syncthing](https://syncthing.net/) website for more.

Tested on following archs:

* x64

Following arch are missing tests:

* arm32v6

## Available image tags

* `nventiveux/syncthing`
  * `latest`, `v1.19.1` ([Dockerfile.amd64](Dockerfile.amd64))
  * `latest-arm32v6`, `v1.19.1-arm32v6` ([Dockerfile.arm32v6](Dockerfile.arm32v6))

## Usage

Run the container manually (select tag according to the target architecture):

```shell
{
mkdir -p "${HOME}/Sync";
docker run \
  -d \
  --name syncthing \
  -p 8384:8384/tcp \
  -p 22000:22000/tcp \
  -p 21027:21027/udp \
  -v syncthing_config:/etc/syncthing \
  -v "${HOME}/Sync":/var/lib/syncthing \
  nventiveux/syncthing:latest;
}
```

Open the administration website with [https://localhost:8384/](https://localhost:8384/) and connect using `admin / admin`.

This will make available for syncing all folders within `~/Sync`. You may be interested to adapt environment variables `SYNCTHING_USER_UID` and `SYNCTHING_GROUP_GID` to match your user UID / GID at the host (verify with `id`).

## Persisting data

Following paths within the container should be persisted:

* `/var/lib/syncthing` holds synced content.
* `/etc/syncthing` holds the syncthing configuration.

## Network ports

* Default ports:
  * `21027/udp` --> Local discovery (see **Known issues**)
  * `22000/tcp` --> Sync protocol
  * `8384/tcp` --> Admin interface

## Environment variables

You can configure Syncthing injecting following environment variables:

| Variable                 | Description                                  | Default     |
|--------------------------|----------------------------------------------|-------------|
| SYNCTHING_USER           | Name of container user                       | `syncthing` |
| SYNCTHING_USER_UID       | Map container user to this UID               | `1000`      |
| SYNCTHING_GROUP          | Name of container user primary group         | `syncthing` |
| SYNCTHING_GROUP_GID      | Map container user primary group to this GID | `1000`      |
| SYNCTHING_ADMIN_USER     | Admin username                               | `admin`     |
| SYNCTHING_ADMIN_PASSWORD | Admin password                               | `admin`     |

Example to set another password for the admin user:

```shell
docker run \
  ...
  -e SYNCTHING_ADMIN_PASSWORD="anotherpassword" \
  ...
```

## Known issues

* Local discovery does not work without `--network=host`. Need more testing if this can be avoided.

## Contribute

Pre-requisites:

* Python >=3.7
* [Pipenv](https://github.com/pypa/pipenv)
* make
* Bash >=4
* Git >=2.18

Prepare your environment:

```shell
make install
```

Tweak `Dockerfile.j2` to your convenience (we are using [Jinja2](http://jinja.pocoo.org/)) and update templates with:

```shell
make dockerfiles
```

**Note**: if you are upgrading Syncthing to a newer version, also [sync the config file version](https://github.com/syncthing/syncthing/blob/main/lib/config/config.go#L32) !

Commit changes and submit a **Pull Request**.

### Releasing a new version

Bump the version using [bump2version](https://github.com/c4urself/bump2version):

```shell
pipenv run bump2version --new-version <VERSION> patch
```

Example: new syncthing release v2.2.4 is released but current version of the image is v1.19.1:

```shell
pipenv run bump2version --new-version 2.2.4-0 patch
```

This will update to syncthing version **v2.2.4** and tag the image with **v2.2.4-0**.

## References

* Inspiration taken from [tianon/dockerfiles](https://github.com/tianon/dockerfiles).
