# Syncthing Docker image

Syncthing Docker image for RaspberryPi / amd64 systems.

> Syncthing replaces proprietary sync and cloud services with something open, trustworthy and decentralized.

See [Syncthing](https://syncthing.net/) website for more.

Tested on:

* Archlinux (amd64)
* RaspberryPi 2 (Model B)
* RaspberryPi 3 (Model B)

## Available image tags

* `nventiveux/syncthing`
  * `latest`, `v1.1.4-0` ([Dockerfile.amd64](Dockerfile.amd64))
  * `latest-arm32v6`, `v1.1.4-0-arm32v6` ([Dockerfile.arm32v6](Dockerfile.arm32v6))

## Usage

Run the container manually:

```shell
$ docker run \
    -d \
    --name syncthing \
    -p 8384:8384/tcp \
    -p 22000:22000/tcp \
    -p 21027:21027/udp \
    -v syncthing_config:/etc/syncthing \
    -v syncthing_data:/var/lib/syncthing \
    nventiveux/syncthing:latest
```

## Persisting data

Following paths should be persisted:

* `/var/lib/syncthing` holds synced content.
* `/etc/syncthing` holds the syncthing configuration.

## Network ports

* Default ports:
  * `21027/udp` --> Local discovery
  * `22000/tcp` --> Sync protocol
  * `8384/tcp` --> Admin interface

## References

* Inspiration taken from [tianon/dockerfiles](https://github.com/tianon/dockerfiles).
