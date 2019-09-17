#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/root}";

VAGRANT_INSECURE_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"

mkdir -p $HOME_DIR/.ssh;
echo "${VAGRANT_INSECURE_KEY}" > $HOME_DIR/.ssh/authorized_keys
chmod 600 $HOME_DIR/.ssh/authorized_keys
# chown -R $SSH_USER:$SSH_USER $SSH_USER_HOME/.ssh

# chown -R vagrant $HOME_DIR/.ssh;
# chmod -R go-rwsx $HOME_DIR/.ssh;

# Disable password based SSH for all users now that we have a key in place
if $(grep -q '^PasswordAuthentication yes' /etc/ssh/sshd_config)
then
    sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
else
    echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
fi
