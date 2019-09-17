#!/usr/bin/env bash

PASSWORD=$(/usr/bin/openssl passwd -crypt 'vagrant')

# vagrant-specific configurator (needs deletion post provision)
/usr/bin/useradd --password ${PASSWORD} --comment 'Vagrant User' --user-group vagrant

echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/10_vagrant

echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_vagrant

/usr/bin/chmod 0440 /etc/sudoers.d/10_vagrant

/usr/bin/systemctl start sshd.service
