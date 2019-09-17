#!/usr/bin/env bash

# https://gist.github.com/rasschaert/0bb7ebc506e26daee585

# stop on errors
set -eu;

TARGET_DIR='/mnt'
UEFI=${UEFI:-0}
DISK=${DISK:-/dev/vda}

if [[ ${#FULL_DISK_ENCRYPTION_PASSWORD} -lt 8 ]]; then
    echo "[!] Bad FULL_DISK_ENCRYPTION_PASSWORD!!!!"
    exit 1
fi

echo '[*] Listing Drives'
fdisk -l
echo ""

echo "[*] Using Disk: $DISK"
fdisk -l $DISK
echo ""

echo "[*] Clearing Disk: $DISK"
sgdisk --zap-all $DISK
echo ""

echo "[*] Partitioning Disk: $DISK => ${DISK}1 "
if [[ $UEFI -eq 1 ]]; then
    printf "n\n1\n\n+1G\nef00\nw\ny\n" | gdisk $DISK
else
    printf "n\np\n1\n\n+200M\nw\n" | fdisk $DISK
fi
echo ""

echo '[*] Listing Drives'
fdisk -l $DISK
echo ""

# boot part
echo "[*] Making Filesystem: ${DISK}1"
if [[ $UEFI -eq 1 ]]; then
    yes | mkfs.fat -F32 ${DISK}1
else
    yes | mkfs.ext2 ${DISK}1
fi
echo ""

echo "[*] Partitioning Disk: $DISK => ${DISK}2"
if [[ $UEFI -eq 1 ]]; then
    # n 2 . 8e00 w y 
    printf "n\n2\n\n\n8e00\nw\ny\n"| gdisk $DISK
else
    # n p 2 . t 2 8e w
    printf "n\np\n2\n\n\nt\n2\n8e\nw\n" | fdisk ${DISK}
fi
echo ""

echo '[*] Listing Drives'
fdisk -l $DISK
echo ""

echo "[*] Setting up encryption"
printf "%s" "$FULL_DISK_ENCRYPTION_PASSWORD" | cryptsetup luksFormat ${DISK}2 -
printf "%s" "$FULL_DISK_ENCRYPTION_PASSWORD" | cryptsetup open --type luks ${DISK}2 lvm -
echo ""

echo "[*] Setting up LVM"
pvcreate /dev/mapper/lvm
vgcreate vg00 /dev/mapper/lvm
lvcreate -l +100%FREE vg00 -n lvroot

# lvcreate -L 20G vg00 -n lvroot
# lvcreate -l +100%FREE vg00 -n lvhome
echo ""

echo "[*] Creating ext4 file systems on top of logical volumes"

# change to ext4
yes | mkfs.ext4 /dev/mapper/vg00-lvroot
# yes | mkfs.ext4 /dev/mapper/vg00-lvhome
echo ""

echo "[*] Mounting /dev/vg00/lvroot"
mount /dev/vg00/lvroot $TARGET_DIR
mkdir $TARGET_DIR/boot
# mkdir $TARGET_DIR/{boot,home}
echo ""

echo "[*] Mounting ${DISK}1"
mount ${DISK}1 /mnt/boot
echo ""

# echo "[*] Mounting /dev/vg00/lvhome"
# mount /dev/vg00/lvhome $TARGET_DIR/home
echo ""
