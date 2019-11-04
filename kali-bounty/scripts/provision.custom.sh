#!/bin/sh -eux
TOOL_DIR=${TOOL_DIR:-/opt}

export DEBIAN_FRONTEND=noninteractive;

echo "Starting Custom installs";

echo "Installing basic dependencies and packages: git seclists golang gobuster vim masscan mlocate tmux masscan burpsuite zaproxy";

# Put apps here to be installed
apt-get install -y git python3-dev python3-pip python-pip unzip seclists golang gobuster vim masscan mlocate tmux masscan nikto burpsuite zaproxy;


## RECON 

## All.txt
if [ ! -d ${TOOL_DIR}/wordlists ]; then 
    echo "Setting up: all.txt";
    mkdir ${TOOL_DIR}/wordlists;
    wget https://gist.github.com/jhaddix/f64c97d0863a78454e44c2f7119c2a6a/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt -O ${TOOL_DIR}/wordlists/all.txt;
fi

## Amass Source
if [ ! -d ${TOOL_DIR}/amass ]; then 
    echo "Setting up: Amass";
    git clone https://github.com/OWASP/Amass.git ${TOOL_DIR}/amass;
    ## Amass Binary
    rm -rf /tmp/amass || true; 
    mkdir /tmp/amass;
    AMASS_NAME=amass_v3.2.3_linux_amd64
    wget https://github.com/OWASP/Amass/releases/download/v3.2.3/$AMASS_NAME.zip -O /tmp/amass/amass.zip;
    unzip -o -d /tmp/amass /tmp/amass/amass.zip;
    mv /tmp/amass/$AMASS_NAME/amass /usr/local/bin/;
    rm -rf /tmp/amass;
fi

## MassDNS Source
if [ ! -d ${TOOL_DIR}/massdns ]; then 
    echo "Setting up: MassDNS";
    git clone https://github.com/blechschmidt/massdns.git ${TOOL_DIR}/massdns;
    ## MassDNS Binary
    cd ${TOOL_DIR}/massdns;
    make
    chmod +x ${TOOL_DIR}/massdns/bin/massdns;
    cp ${TOOL_DIR}/massdns/bin/massdns /usr/local/bin/
fi

# Eyewitness + Aquatone Dependencies
echo "Installing: eyewitness + Aquatone Dependencies";
apt-get install -y firefox-esr chromium xvfb;

## EyeWitness Source
if [ ! -d ${TOOL_DIR}/EyeWitness ]; then 
    echo "Setting up: EyeWitness";
    git clone https://github.com/FortyNorthSecurity/EyeWitness.git ${TOOL_DIR}/EyeWitness;
    ## EyeWitness Binary
    bash ${TOOL_DIR}/EyeWitness/setup/setup.sh;
    chmod +x ${TOOL_DIR}/EyeWitness/EyeWitness.py
    ln -s ${TOOL_DIR}/EyeWitness/EyeWitness.py /usr/local/bin/eyewitness;
fi

## Aquatone Source
if [ ! -d ${TOOL_DIR}/aquatone ]; then 
    echo "Setting up: Aquatone";
    git clone https://github.com/michenriksen/aquatone.git ${TOOL_DIR}/aquatone;
    ## Aquatone Binary
    rm -rf /tmp/aquatone || true;
    mkdir /tmp/aquatone;
    wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip -O /tmp/aquatone/aquatone.zip;
    unzip -o -d /tmp/aquatone /tmp/aquatone/aquatone.zip
    mv /tmp/aquatone/aquatone /usr/local/bin/
    rm -rf /tmp/aquatone;
fi

## Dirsearch Source
if [ ! -d ${TOOL_DIR}/dirsearch ]; then 
    echo "Setting up: Dirsearch";
    git clone https://github.com/maurosoria/dirsearch.git ${TOOL_DIR}/dirsearch;
    ## DirSearch Binary
    ln -s ${TOOL_DIR}/dirsearch/dirsearch.py /usr/local/bin/dirsearch;
fi

## GitRob Source
if [ ! -d ${TOOL_DIR}/gitrob ]; then 
    echo "Setting up: GitRob";
    git clone https://github.com/michenriksen/gitrob.git ${TOOL_DIR}/gitrob;
    ## GitRob Binary 
    rm -rf /tmp/gitrob || true;
    mkdir /tmp/gitrob;
    wget https://github.com/michenriksen/gitrob/releases/download/v2.0.0-beta/gitrob_linux_amd64_2.0.0-beta.zip -O /tmp/gitrob/gitrobbeta.zip;
    unzip -o -d /tmp/gitrob /tmp/gitrob/gitrobbeta.zip
    mv /tmp/gitrob/gitrob /usr/local/bin/gitrobbeta;
    rm -rf /tmp/gitrob;
fi

## SubFinder Source
if [ ! -d ${TOOL_DIR}/subfinder ]; then 
    echo "Setting up: SubFinder";
    git clone https://github.com/subfinder/subfinder.git ${TOOL_DIR}/subfinder;
    ## SubFinder Binary (Releases too old)
fi

## Assetfinder
if [ ! -d ${TOOL_DIR}/assetfinder ]; then 
    echo "Setting up: AssetFinder";
    git clone https://github.com/tomnomnom/assetfinder.git ${TOOL_DIR}/assetfinder;
fi

## Arjun
if [ ! -d ${TOOL_DIR}/arjun ]; then 
    echo "Setting up: Arjun";
    git clone https://github.com/s0md3v/Arjun.git ${TOOL_DIR}/arjun;
fi

## Xsstrike
if [ ! -d ${TOOL_DIR}/xsstrike ]; then 
    echo "Setting up: XSStrike";
    git clone https://github.com/s0md3v/XSStrike.git ${TOOL_DIR}/xsstrike;
fi

## Testssl
if [ ! -d ${TOOL_DIR}/testssl ]; then 
    echo "Setting up: Testssl";
    git clone https://github.com/drwetter/testssl.sh.git ${TOOL_DIR}/testssl;
fi

## Discover Scripts Dependencies
echo "Installing Discover Scripts dependencies";
DEBIAN_FRONTEND=noninteractive apt-get install -y dnsrecon libjpeg-dev zlib1g-dev python-pyftpdlib python3-pyftpdlib python-pil python3-lxml recon-ng python-lxml python3-pil urlcrazy

## Discover Scripts Source
if [ ! -d /opt/discover ]; then 
    echo "Setting up: Discover Scripts";
    git clone https://github.com/leebaird/discover.git /opt/discover;
    cd /opt/discover;
    ## Discover Scripts Needs Egress-Assess Preinstalled for Non-interactive
    echo "Setting up: Egress-Assess (on behalf of discover scripts)"
    git clone https://github.com/ChrisTruncer/Egress-Assess.git /opt/Egress-Assess;
    printf "\n\n\n\n\n\n\n" | /opt/Egress-Assess/setup/setup.sh
    mv server.pem ../Egress-Assess/
    rm impacket*
    ## Discover Scripts Install
    DEBIAN_FRONTEND=noninteractive ./update.sh || echo "Discover scripts had issues. Continueing"
fi

## Pentesting
if [ ! -d ${TOOL_DIR}/nishang ]; then 
    echo "Setting up: Nishang";
    git clone https://github.com/samratashok/nishang.git ${TOOL_DIR}/nishang;
fi

## Desktop
# Mate/xfce Don't work with spice, use gnome :/
# vgamem may need to be 65536 or 65536/2
# spice channel needs to exist

echo "Updating package repositories";
apt-get update
echo "Installing gnome";
DEBIAN_FRONTEND=noninteractive apt-get install -y gnome-core kali-defaults kali-root-login desktop-base xinit;
echo "Setting up: gnome";
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false || echo 'Failed Gnome Setting';
gsettings set org.gnome.desktop.screensaver lock-enabled false || echo 'Failed Gnome Setting';
gsettings set org.gnome.desktop.screensaver lock-delay 0 || echo 'Failed Gnome Setting';
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing' || echo 'Failed Gnome Setting';
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing' || echo 'Failed Gnome Setting';
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false || echo 'Failed Gnome Setting';
gsettings set org.gnome.desktop.session idle-delay 0 || echo 'Failed Gnome Setting';
gsettings set org.gnome.desktop.screensaver lock-enabled true || echo 'Failed Gnome Setting';

systemctl enable spice-vdagent || true;
systemctl enable spice-vdagentd || true;

echo "Custom installs complete";