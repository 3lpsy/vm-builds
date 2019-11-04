#!/bin/sh -eux

export DEBIAN_FRONTEND=noninteractive;

# Disable automatic udev rules for network interfaces in Ubuntu,
# source: http://6.ptmc.org/164/
# rm -f /etc/udev/rules.d/70-persistent-net.rules;
# mkdir -p /etc/udev/rules.d/70-persistent-net.rules;
# rm -f /lib/udev/rules.d/75-persistent-net-generator.rules;
# rm -rf /dev/.udev/ /var/lib/dhcp/*;

echo "Installing Network Manager";
apt-get install -y network-manager
systemctl enable network-manager