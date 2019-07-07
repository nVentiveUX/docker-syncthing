FROM alpine:3.10

LABEL authors="nVentiveUX <https://github.com/nVentiveUX>"
LABEL license="MIT"
LABEL description="Docker image for syncthing installation. \
Think for ARM / x64 devices."

# User definition environment variables
ENV SYNCTHING_USER="syncthing" \
    SYNCTHING_USER_UID=1000 \
    SYNCTHING_GROUP="syncthing" \
    SYNCTHING_GROUP_GID=1000 \
    SYNCTHING_ADMIN_USER="admin" \
    SYNCTHING_ADMIN_PASSWORD="admin"

# gpg: key 00654A3E: public key "Syncthing Release Management <release@syncthing.net>" imported
ENV SYNCTHING_GPG_KEY 37C84554E7E0A261E4F76E1ED26E6ED000654A3E
ENV SYNCTHING_VERSION 1.1.4

RUN set -ex \
  && apk add --no-cache bash shadow su-exec py3-bcrypt py3-cryptography

RUN set -ex \
  && apk add --no-cache --virtual .temp-deps gnupg openssl \
  && tarball="syncthing-linux-amd64-v${SYNCTHING_VERSION}.tar.gz" \
  && wget \
    "https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/$tarball" \
    "https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/sha1sum.txt.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "${SYNCTHING_GPG_KEY}" \
  && gpg --batch --decrypt --output sha1sum.txt sha1sum.txt.asc \
  && grep -E " ${tarball}\$" sha1sum.txt | sha1sum -c - \
  && rm -rf "$GNUPGHOME" sha1sum.txt sha1sum.txt.asc \
  && dir="$(basename "$tarball" .tar.gz)" \
  && bin="$dir/syncthing" \
  && tar -xvzf "$tarball" "$bin" \
  && rm "$tarball" \
  && mv "$bin" /usr/local/bin/syncthing \
  && rmdir "$dir" \
  && apk del .temp-deps;

RUN set -ex \
  && mkdir -p /etc/syncthing /var/lib/syncthing

COPY ./config.xml /etc/syncthing
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

VOLUME ["/etc/syncthing", "/var/lib/synchting"]

EXPOSE 8384 22000 21027/udp

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["syncthing", "-home=/etc/syncthing", "-logflags=0"]
