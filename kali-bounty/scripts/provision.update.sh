#!/bin/sh -eux
export DEBIAN_FRONTEND=noninteractive;

arch="`uname -r | sed 's/^.*[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\(-[0-9]\{1,2\}\)-//'`"

apt-get update;

apt-get -y upgrade linux-image-$arch;
apt-get -y install linux-headers-`uname -r`;
apt-get -y install build-essential wget
apt-get -y dist-upgrade