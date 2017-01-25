FROM nventiveux/docker-alpine-rpi:3.5

MAINTAINER nVentiveUX

LABEL authors="Yves ANDOLFATTO, Vincent BESANCON"
LABEL license="MIT"
LABEL description="Docker image for syncthing installation. \
Think for RaspberryPi."

# gpg: key 00654A3E: public key "Syncthing Release Management <release@syncthing.net>" imported
ENV SYNCTHING_GPG_KEY 37C84554E7E0A261E4F76E1ED26E6ED000654A3E

ENV SYNCTHING_VERSION 0.14.21

RUN set -x \
  && apk add --no-cache --virtual .temp-deps gnupg openssl \
  && tarball="syncthing-linux-arm-v${SYNCTHING_VERSION}.tar.gz" \
  && wget \
    "https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/$tarball" \
    "https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/sha1sum.txt.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "${SYNCTHING_GPG_KEY}" \
  && gpg --batch --decrypt --output sha1sum.txt sha1sum.txt.asc \
  && grep -E " ${tarball}\$" sha1sum.txt | sha1sum -c - \
  && rm -r "$GNUPGHOME" sha1sum.txt sha1sum.txt.asc \
  && dir="$(basename "$tarball" .tar.gz)" \
  && bin="$dir/syncthing" \
  && tar -xvzf "$tarball" "$bin" \
  && rm "$tarball" \
  && mv "$bin" /usr/local/bin/syncthing \
  && rmdir "$dir" \
  && apk del .temp-deps;

RUN addgroup -S -g 500 syncthing && \
  adduser -S -u 500 -D -G syncthing syncthing;

RUN mkdir -p /etc/syncthing /syncedfolders

COPY ./config.xml /etc/syncthing

RUN chown -R syncthing:syncthing /etc/syncthing

VOLUME ["/etc/syncthing"]

EXPOSE 8384 22000 21027/udp

USER syncthing

ENTRYPOINT ["/usr/local/bin/syncthing"]

CMD ["-home=/etc/syncthing", "-logflags=0"]
