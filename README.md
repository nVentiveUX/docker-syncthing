# docker-syncthing

Syncthing Docker image for RaspberryPi.

## Quick start

Clone this repository and build the Docker image.

```shell
$ git clone git@ssh.github.com:nVentiveUX/docker-syncthing.git
$ cd docker-syncthing
$ docker build --rm -t nventiveux/docker-syncthing:0.14.18 .
```

Run the container

```shell
$ docker run -d \
  --name syncthing \
  --restart always \
  -p 8384:8384 \
  -p 22000:22000 \
  -v "$HOME/.config/syncthing:/home/user/.config/syncthing" \
  nventiveux/docker-syncthing:0.14.18
```

## References

Based on [tianon/dockerfiles](https://github.com/tianon/dockerfiles).
