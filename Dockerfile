FROM nventiveux/docker-alpine-rpi:3.5

MAINTAINER nVentiveUX

LABEL authors="Yves ANDOLFATTO, Vincent BESANCON"
LABEL license="MIT"
LABEL description="Docker image for syncthing installation. \
Think for RaspberryPi."

ENV SYNCTHING_VERSION 0.14.18

RUN set -x && \
  apk update && \
  apk add --no-cache curl tar gzip gnupg && \
  tarball="syncthing-linux-arm-v${SYNCTHING_VERSION}.tar.gz" && \
  curl -fSL "https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/"{"$tarball",sha1sum.txt.asc} -O && \
  grep -E " ${tarball}\$" sha1sum.txt.asc | sha1sum -c - && \
  rm sha1sum.txt.asc && \
  tar -xvf "$tarball" --strip-components=1 "$(basename "$tarball" .tar.gz)"/syncthing && \
  mv syncthing /usr/local/bin/syncthing && \
  rm "$tarball" && \
  apk del curl tar gzip gnupg;

RUN addgroup -S -g 500 syncthing && \
  adduser -S -u 500 syncthing syncthing;

RUN mkdir -p /etc/syncthing/main /syncedfolders

COPY ./config.xml /etc/syncthing/main

RUN chown -R syncthing:syncthing /etc/syncthing

VOLUME ["/home/syncthing/.config/syncthing"]

EXPOSE 8384 22000 21027/udp

USER syncthing

ENTRYPOINT ["/usr/local/bin/syncthing"]

CMD ["-home=/etc/syncthing/main", "-logflags=0"]
