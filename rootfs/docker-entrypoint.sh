#!/bin/bash

set -u -o pipefail
trap 'on_error ${LINENO}' ERR

SYNCTHING_ADMIN_PASSWORD_HASH="$(python3 -c 'import bcrypt, os; print(bcrypt.hashpw(os.getenv("SYNCTHING_ADMIN_PASSWORD").encode("utf-8"), bcrypt.gensalt()).decode("utf-8"))')"

on_error() {
    printf "\\nEntrypoint terminated. Error encountered on line %s\\n" "${1}"
    exit 2
}

get_ownerships() {
    local path="${1}"; shift

    output=$(stat --printf='%u:%g' "${path}" 2>/dev/null); rc=$?
    if [[ ${rc} == 0 ]]
    then
        printf "%s\\n" "${output}"
        return 0
    else
        printf "Error: cannot get ownership of \"%s\" !\\n" "${path}"
        return 1
    fi
}

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

if ownerships=$(get_ownerships /etc/syncthing)
then
    if [[ "${ownerships}" != "${SYNCTHING_USER_UID}":"${SYNCTHING_GROUP_GID}" ]]
    then
        printf "* Set ownerships of files: %s ... " "${SYNCTHING_USER_UID}":"${SYNCTHING_GROUP_GID}"
        chown -R \
            "${SYNCTHING_USER}":"${SYNCTHING_GROUP}" \
            "/etc/syncthing" \
            "/var/lib/syncthing"
        printf "DONE.\\n"
    else
        printf "* Ownerships of files are up-to-date.\\n"
    fi
else
    rc=$?
    printf "%s\\n" "${ownerships}"
    printf "Fatal error on line %s.\\n" "${LINENO}"
    exit ${rc}
fi

printf "* Updating configuration file... "
sed -i -r \
    -e "s#<user>.*</user>#<user>${SYNCTHING_ADMIN_USER}</user>#g" \
    -e "s#<password>.*</password>#<password>${SYNCTHING_ADMIN_PASSWORD_HASH}</password>#g" \
    /etc/syncthing/config.xml
printf "DONE.\\n"

exec su-exec syncthing "$@"
