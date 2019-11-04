#!/bin/sh -eux
TOOL_DIR=${TOOL_DIR:-/opt}

export DEBIAN_FRONTEND=noninteractive;

# Put apps here to be installed
apt-get install -y git \
seclists \
golang \
gobuster \
vim \
masscan \
mlocate \
tmux \
build-essential;

systemctl enable spice-vdagent;
systemctl enable spice-vdagentd;

## RECON 
mkdir ${TOOL_DIR}/wordlists;
wget https://gist.github.com/jhaddix/f64c97d0863a78454e44c2f7119c2a6a/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt -O ${TOOL_DIR}/wordlists/all.txt;

## Amass Source
git clone https://github.com/OWASP/Amass.git ${TOOL_DIR}/amass;
## Amass Binary
rm -rf /tmp/amass || true; 
mkdir /tmp/amass;
AMASS_NAME=amass_v3.2.3_linux_amd64
wget https://github.com/OWASP/Amass/releases/download/v3.2.3/$AMASS_NAME.zip -O /tmp/amass/amass.zip;
unzip -o -d /tmp/amass /tmp/amass/amass.zip;
rm /tmp/amass/amass.zip;
mv /tmp/amass/$AMASS_NAME/amass /usr/local/bin/;

## MassDNS Source
git clone https://github.com/blechschmidt/massdns.git ${TOOL_DIR}/massdns;
## MassDNS Binary
cd ${TOOL_DIR}/massdns;
make
chmod +x ${TOOL_DIR}/massdns/bin/massdns;
cp ${TOOL_DIR}/massdns/bin/massdns /usr/local/bin/

# Eyewitness + Aquatone Dependencies
apt-get install -y firefox-esr chromium xvfb;

## EyeWitness Source
git clone https://github.com/FortyNorthSecurity/EyeWitness.git ${TOOL_DIR}/eyewitness;
## EyeWitness Binary
bash ${TOOL_DIR}/eyewitness/setup/setup.sh;
chmod +x ${TOOL_DIR}/eyewitness/EyeWitness.py
ln -s ${TOOL_DIR}/eyewitness/EyeWitness.py /usr/local/bin/eyewitness;

## Aquatone Source
git clone https://github.com/michenriksen/aquatone.git ${TOOL_DIR}/aquatone;
## Aquatone Binary
rm -rf /tmp/aquatone || true;
mkdir /tmp/aquatone;
wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip -O /tmp/aquatone/aquatone.zip;
unzip -o -d /tmp/aquatone /tmp/aquatone/aquatone.zip
mv /tmp/aquatone/aquatone /usr/local/bin/
rm -rf /tmp/aquatone;

## Dirsearch Source
git clone https://github.com/maurosoria/dirsearch.git ${TOOL_DIR}/dirsearch;
## DirSearch Binary
ln -s ${TOOL_DIR}/dirsearch/dirsearch.py /usr/local/bin/dirsearch;

## GitRob Source
git clone https://github.com/michenriksen/gitrob.git ${TOOL_DIR}/gitrob;
## GitRob Binary 
rm -rf /tmp/gitrob || true;
mkdir /tmp/gitrob;
wget https://github.com/michenriksen/gitrob/releases/download/v2.0.0-beta/gitrob_linux_amd64_2.0.0-beta.zip -O /tmp/gitrob/gitrobbeta.zip;
unzip -o -d /tmp/gitrob /tmp/gitrob/gitrobbeta.zip
mv /tmp/gitrob/gitrob /usr/local/bin/gitrobbeta;
rm -rf /tmp/gitrob;

## SubFinder Source
git clone https://github.com/subfinder/subfinder.git ${TOOL_DIR}/subfinder;
## SubFinder Binary (Releases too old)

git clone https://github.com/tomnomnom/assetfinder.git ${TOOL_DIR}/assetfinder;
git clone https://github.com/s0md3v/Arjun.git ${TOOL_DIR}/arjun;
git clone https://github.com/s0md3v/XSStrike.git ${TOOL_DIR}/xsstrike;


## Discover Scripts Dependencies
DEBIAN_FRONTEND=noninteractive apt-get install -y libjpeg-dev zlib1g-dev python-pyftpdlib python3-pyftpdlib python-pil python3-pil urlcrazy
## Discover Scripts Source
git clone https://github.com/leebaird/discover.git /opt/discover;
cd /opt/discover;
## Discover Scripts Needs Egress-Assess Preinstalled for Non-interactive
git clone https://github.com/ChrisTruncer/Egress-Assess.git /opt/Egress-Assess;
printf "\n\n\n\n\n\n\n" | /opt/Egress-Assess/setup/setup.sh
mv server.pem ../Egress-Assess/
rm impacket*
## Discover Scripts Install
DEBIAN_FRONTEND=noninteractive ./update.sh

## Pentesting

git clone https://github.com/samratashok/nishang.git ${TOOL_DIR}/nishang;


## Desktop

## Fix Udev Rules
rm -rf /etc/udev/rules.d/70-persistent-net.rules || true
sudo udevadm trigger --subsystem-match=net --action=add || true;

# Mate/xfce Don't work with spice, use gnome :/
# apt-get install -y desktop-base mate-desktop-environment spice-vdagent xserver-xspice xserver-xorg-video-qxl xinit lightdm

# vgamem may need to be 65536 or 65536/2
# spice channel needs to exist
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y gnome-core kali-defaults kali-root-login desktop-base spice-vdagent xserver-xspice xserver-xorg-video-qxl xinit;
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver lock-delay 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled true

