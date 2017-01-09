# docker-syncthing

Syncthing Docker image for RaspberryPi.

> Syncthing replaces proprietary sync and cloud services with something open, trustworthy and decentralized.

See [Syncthing](https://syncthing.net/) website for more.

Tested on:

* RaspberryPi 2 (Model B)
* RaspberryPi 3 (Model B)

**Note**: this is still under heavy development and testing. Feedbacks / Pull requests are welcome !

## Quick install

```shell
$ curl -sSL https://raw.githubusercontent.com/nVentiveUX/docker-syncthing/master/installer.sh | sudo bash
```

* Ensure [Docker Engine](https://www.docker.com/products/overview) is installed.
* Install as a **systemd service** container stop / start.
* Install service options in `/etc/default`.
* Set service start at boot.

## Run multiple instances

Define an instance name, replace `<NAME>` by something suitable for you:

```shell
$ INSTANCE_NAME="<NAME>"
```

Setup the new instance as a **systemd service**:

```shell
$ {
sudo cp systemd/docker-syncthing@.service /etc/systemd/system/ &&
sudo cp systemd/docker-syncthing@.default /etc/default/docker-syncthing@${INSTANCE_NAME} &&
sudo systemctl daemon-reload &&
sudo systemctl enable docker-syncthing@${INSTANCE_NAME}.service;
}
```

Edit instance options:

```shell
$ sudo vi /etc/default/docker-syncthing@${INSTANCE_NAME}
```

Start new instance:

```shell
$ sudo systemctl start docker-syncthing@${INSTANCE_NAME}
```

Repeat these steps to setup others instances.

## Build image and test

Clone this repository and build the Docker image:

```shell
$ git clone https://github.com/nVentiveUX/docker-syncthing.git
$ cd docker-syncthing
$ docker build --rm -t nventiveux/docker-syncthing:latest .
```

Run it !

```shell
$ docker run \
    --rm \
    --name syncthing \
    -p 8384:8384 -p 22000:22000 \
    nventiveux/docker-syncthing:latest
```

Persist syncthing database and configuration by creating a [volume or data container](https://docs.docker.com/engine/tutorials/dockervolumes/) with:

```shell
$ docker run \
    --rm \
    --name syncthing \
    -p 8384:8384 -p 22000:22000 \
    -v syncthing_data:/etc/syncthing \
    nventiveux/docker-syncthing:latest
```

Use `/syncedfolders` to store synced content to the syncthing container:

```shell
$ docker run \
    --rm \
    --name syncthing \
    -p 8384:8384 -p 22000:22000 \
    -v syncthing_data:/etc/syncthing \
    -v /work:/syncedfolders/work \
    nventiveux/docker-syncthing:latest
```

## References

* Inspiration taken from [tianon/dockerfiles](https://github.com/tianon/dockerfiles).
