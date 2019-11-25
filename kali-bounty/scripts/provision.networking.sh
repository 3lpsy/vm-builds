#!/bin/sh -eux

export DEBIAN_FRONTEND=noninteractive;

# Disable automatic udev rules for network interfaces in Ubuntu,
# source: http://6.ptmc.org/164/
# rm -f /etc/udev/rules.d/70-persistent-net.rules;
# mkdir -p /etc/udev/rules.d/70-persistent-net.rules;
# rm -f /lib/udev/rules.d/75-persistent-net-generator.rules;
# rm -rf /dev/.udev/ /var/lib/dhcp/*;

# echo "Installing Network Manager";
# apt-get install -y network-manager
# systemctl enable network-manager

echo "Installing openresolv"
sudo apt-get install openresolv -y
sudo apt install software-properties-common -y 
echo "Adding Wireguard repo" 
printf "\n" | sudo add-apt-repository ppa:wireguard/wireguard -y 
echo "Updating" 
sudo apt-get update 
echo "Installing Wireguard" 
sudo apt-get install -y wireguard-dkms wireguard-tools;

WG_CONF=$(cat << EOF
[Interface]
Address = 10.200.200.2/24
PrivateKey = YYYY
DNS = 10.200.200.1

[Peer]
PublicKey = XXXX
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = AAAA:BBBB
PersistentKeepalive = 21

EOF
)

echo "$WG_CONF" | sudo tee /etc/wireguard/wg0.conf.example