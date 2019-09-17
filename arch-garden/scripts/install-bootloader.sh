#!/usr/bin/env bash

# stop on errors
set -eu;

TARGET_DIR='/mnt'
DISK=${DISK:-/dev/vda}
UEFI=${UEFI:-0}

echo '[*] Configuring bootloader'

###############################
#### Configure base system ####
###############################
if [[ $UEFI -eq 1 ]]; then
    arch-chroot /mnt /bin/bash <<EOF
echo "[*] Installing Systemd boot loader"
bootctl --path=/boot install
mkdir -p /boot/loader/entries
cat << GRUB > /boot/loader/entries/arch.conf
title          Arch Linux
linux          /vmlinuz-linux
initrd         /initramfs-linux.img
options        cryptdevice=${DISK}2:vg00 root=/dev/mapper/vg00-lvroot rw
GRUB
cat << BASECONF > /boot/loader/loader.conf
default arch
timeout 7
BASECONF
bootctl update
EOF
else
    arch-chroot /mnt /bin/bash <<EOF
echo "[*] Installing Grub boot loader"
pacman --noconfirm -S grub
grub-install --target=i386-pc --recheck ${DISK}
sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet cryptdevice=${DISK}2:vg00 root=/dev/mapper/vg00-lvroot"|' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
EOF
fi
echo '[*] Bootloader Configured'
