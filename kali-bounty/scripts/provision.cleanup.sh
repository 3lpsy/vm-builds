#!/bin/sh -eux

# Delete obsolete networking
echo "Cleaning up";

apt-get -y purge ppp pppconfig pppoeconf || true;
apt-get -y autoremove;
apt-get -y clean;

echo "Clean up complete";


