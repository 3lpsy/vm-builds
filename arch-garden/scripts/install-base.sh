#!/usr/bin/env bash

# stop on errors
set -eu;

TARGET_DIR='/mnt'
TIMEZONE="/usr/share/zoneinfo/America/Chicago"
HOSTNAME="packerforfun"

echo '[*] Pacstrapping base and base-devel'

yes '' | pacstrap -i ${TARGET_DIR} base base-devel

echo '[*] Generating the filesystem table'
/usr/bin/genfstab -p ${TARGET_DIR} >> "${TARGET_DIR}/etc/fstab"

###############################
#### Configure base system ####
###############################

echo '[*] Configuring base system'

arch-chroot /mnt /bin/bash <<EOF
echo "Setting and generating locale"
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
export LANG=en_US.UTF-8
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "Setting time zone"
ln -s ${TIMEZONE} /etc/localtime
echo "Setting hostname"
echo ${HOSTNAME} > /etc/hostname
sed -i "/localhost/s/$/ ${HOSTNAME}/" /etc/hosts
echo "Generating initramfs"
sed -i 's/^HOOKS.*/HOOKS="base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck"/' /etc/mkinitcpio.conf
mkinitcpio -p linux
EOF

echo '[*] Adding workaround for shutdown race condition'
/usr/bin/install --mode=0644 /root/poweroff.timer "${TARGET_DIR}/etc/systemd/system/poweroff.timer"

echo '[*]  Cleanup complete!'
/usr/bin/sleep 3


echo '[*] Base Installation complete!'
