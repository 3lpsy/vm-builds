#!/usr/bin/env bash

# stop on errors
set -eu;

if [[ ${#USERNAME} -lt 3 ]]; then
    echo "[!] Bad USERNAME!!!!"
    exit 1
fi

if [[ ${#USER_PASSWORD} -lt 8 ]]; then
    echo "[!] Bad USER_PASSWORD!!!!"
    exit 1
fi

ENC_PASSWORD=$(/usr/bin/openssl passwd -crypt "$USER_PASSWORD")

# Packer-specific configurator (needs deletion post provision)

arch-chroot /mnt /bin/bash <<EOF
/usr/bin/useradd --password ${ENC_PASSWORD} --comment 'Main User' --create-home --user-group $USERNAME
EOF
