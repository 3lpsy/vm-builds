#!/bin/sh -eux

# Put apps here to be installed
apt-get install -y git \
seclists \
gobuster \
vim \
mlocate;

git clone https://github.com/samratashok/nishang.git /opt/nishang;

# XINIT=$(cat << EOF
# #!/bin/bash
# exec startxfce4;
# EOF
# )

# echo "$XINIT" > /root/.xinitrc;

systemctl enable spice-vdagent;
systemctl enable spice-vdagentd