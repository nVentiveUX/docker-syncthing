FROM alpine:3.14

LABEL authors="nVentiveUX <https://github.com/nVentiveUX>"
LABEL license="MIT"
LABEL description="Docker image for syncthing installation. \
Think for ARM / x64 devices."

SHELL [ "/bin/ash", "-eo", "pipefail", "-c" ]

# User definition environment variables
ENV SYNCTHING_USER="syncthing" \
    SYNCTHING_USER_UID=1000 \
    SYNCTHING_GROUP="syncthing" \
    SYNCTHING_GROUP_GID=1000 \
    SYNCTHING_ADMIN_USER="admin" \
    SYNCTHING_ADMIN_PASSWORD="admin"

ENV SYNCTHING_GPG_KEY1="49F5AEC0BCE524C7" \
    SYNCTHING_GPG_KEY2="D26E6ED000654A3E" \
    SYNCTHING_VERSION="1.28.1" \
    SYNCTHING_ARCH="amd64"

RUN set -x \
  && apk add --no-cache \
    bash \
    coreutils \
    py3-bcrypt \
    py3-cryptography \
    shadow \
    su-exec \
  && apk add --no-cache --virtual .temp-deps \
    gnupg \
    openssl \
  && tarball="syncthing-linux-${SYNCTHING_ARCH}-v${SYNCTHING_VERSION}.tar.gz" \
  && wget --quiet \
    "https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/$tarball" \
    "https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/sha1sum.txt.asc" \
  && GNUPGHOME="$(mktemp -d)" \
  && export GNUPGHOME \
  && gpg --keyserver pgp.cyberbits.eu --recv-keys "${SYNCTHING_GPG_KEY1}" "${SYNCTHING_GPG_KEY2}" \
  && gpg --batch --decrypt --output sha1sum.txt sha1sum.txt.asc \
  && grep -E " ${tarball}\$" sha1sum.txt | sha1sum -c - \
  && rm -rf "$GNUPGHOME" sha1sum.txt sha1sum.txt.asc \
  && dir="$(basename "$tarball" .tar.gz)" \
  && bin="$dir/syncthing" \
  && tar -xvzf "$tarball" "$bin" \
  && rm "$tarball" \
  && mv "$bin" /usr/local/bin/syncthing \
  && rmdir "$dir" \
  && apk del .temp-deps \
  && mkdir -p /etc/syncthing /var/lib/syncthing

COPY rootfs/ /

VOLUME ["/etc/syncthing", "/var/lib/syncthing"]

EXPOSE 8384/tcp 22000/tcp 22000/udp 21027/udp

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["syncthing", "-home=/etc/syncthing", "-logflags=0"]
