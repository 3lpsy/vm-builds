#!/usr/bin/env bash

# stop on errors
set -eu;

COUNTRY=${COUNTRY:-US}

MIRRORLIST="https://www.archlinux.org/mirrorlist/?country=${COUNTRY}&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"

echo "[*] Setting local mirror"

curl -s "$MIRRORLIST" |  sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist
