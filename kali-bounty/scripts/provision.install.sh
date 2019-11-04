#!/bin/sh -eux

export DEBIAN_FRONTEND=noninteractive;

echo "Installing sudo nfs-common portmap rsync";
apt-get install sudo nfs-common portmap rsync -y;
echo "Installing qemu-guest-agent spice-vdagent xserver-xspice";
apt-get install qemu-guest-agent spice-vdagent xserver-xspice xserver-xorg-video-qxl -y;
