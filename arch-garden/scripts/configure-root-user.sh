#!/usr/bin/env bash

# stop on errors
set -eu;

if [[ ${#ROOT_USER_PASSWORD} -lt 8 ]]; then
    echo "[!] Bad ROOT_USER_PASSWORD!!!!"
    exit 1
fi

arch-chroot /mnt /bin/bash <<EOF
echo "Setting root password"
echo "root:${ROOT_USER_PASSWORD}" | chpasswd
EOF
