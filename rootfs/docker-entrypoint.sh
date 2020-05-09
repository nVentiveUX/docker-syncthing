#!/bin/bash

set -eu -o pipefail

SYNCTHING_ADMIN_PASSWORD_HASH="$(python3 -c 'import bcrypt, os; print(bcrypt.hashpw(os.getenv("SYNCTHING_ADMIN_PASSWORD").encode("utf-8"), bcrypt.gensalt()).decode("utf-8"))')"

printf "* Generated salted password: %s\\n" "${SYNCTHING_ADMIN_PASSWORD_HASH}"

if ! getent passwd "${SYNCTHING_USER}" &>/dev/null
then
    printf "* Creating user \"%s\"... " "${SYNCTHING_USER}"
    groupadd -g "${SYNCTHING_GROUP_GID}" "${SYNCTHING_GROUP}"
    useradd -u "${SYNCTHING_USER_UID}" -g "${SYNCTHING_GROUP}" -m -s "/bin/bash" "${SYNCTHING_USER}"
    printf "DONE.\\n"
else
    printf "* Updating user \"%s\"... " "${SYNCTHING_USER}"
    groupmod -g "${SYNCTHING_GROUP_GID}" "${SYNCTHING_GROUP}"
    usermod -u "${SYNCTHING_USER_UID}" -g "${SYNCTHING_GROUP}" "${SYNCTHING_USER}"
    printf "DONE.\\n"
fi

chown -R "${SYNCTHING_USER}":"${SYNCTHING_GROUP}" /etc/syncthing /var/lib/syncthing

printf "* Updating configuration file... "
sed -i -r \
    -e "s#<user>.*</user>#<user>${SYNCTHING_ADMIN_USER}</user>#g" \
    -e "s#<password>.*</password>#<password>${SYNCTHING_ADMIN_PASSWORD_HASH}</password>#g" \
    /etc/syncthing/config.xml
printf "DONE.\\n"

exec su-exec syncthing -home /etc/syncthing "$@"
