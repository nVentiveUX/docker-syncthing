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
$ {
sudo cp docker-syncthing@.service /etc/systemd/system/ &&
sudo systemctl daemon-reload &&
sudo systemctl enable docker-syncthing@$USER.service &&
sudo systemctl start docker-syncthing@$USER.service &&
sudo systemctl status -l docker-syncthing@$USER.service;
}
```

## References

Based on [tianon/dockerfiles](https://github.com/tianon/dockerfiles).
