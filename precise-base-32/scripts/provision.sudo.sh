#!/bin/bash -eux

set -e;

# Add vagrant user to sudoers.
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" | sudo tee -a /etc/sudoers
sudo sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
