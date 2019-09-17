#!/bin/bash

set -e;

echo "Updating repositories..."
sudo apt-get -y clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update

echo "Installing packages"
sudo apt-get install -y vim wget curl build-essential gdb rsync nfs-kernel-server tcpdump unzip git


date > /etc/vagrant_box_build_time

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_PASS=${SSH_PASSWORD:-vagrant}
SSH_USER_HOME=${SSH_USER_HOME:-/home/${SSH_USER}}
VAGRANT_INSECURE_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"


if grep -q -E "^mesg n$" /root/.profile && sed -i "s/^mesg n$/tty -s \\&\\& mesg n/g" /root/.profile; then
  echo "==> Fixed stdin not being a tty."
fi

mkdir $SSH_USER_HOME/.ssh
chmod 700 $SSH_USER_HOME/.ssh
cd $SSH_USER_HOME/.ssh

echo "${VAGRANT_INSECURE_KEY}" | sudo tee $SSH_USER_HOME/.ssh/authorized_keys
chmod 600 $SSH_USER_HOME/.ssh/authorized_keys
chown -R $SSH_USER:$SSH_USER $SSH_USER_HOME/.ssh

echo "UseDNS no" | sudo tee -a /etc/ssh/sshd_config

echo "Cleaning up..."

rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules
rm /var/lib/dhcp/*
echo "pre-up sleep 2" >> /etc/network/interfaces
apt-get -y autoremove --purge
apt-get -y clean
apt-get -y autoclean

unset HISTFILE
rm -f /root/.bash_history
rm -f /home/${SSH_USER}/.bash_history

find /var/log -type f | while read f; do echo -ne '' > "${f}"; done;

>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp

echo "Setup complete..."
