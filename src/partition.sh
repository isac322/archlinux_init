#!/usr/bin/env sh

parted -s /dev/sda mklabel gpt mkpart ESP fat32 1% 513MiB mkpart primary ext4 513MiB 10.5GiB \
 mkpart primary linux-swap 10.5GiB 14.5GiB mkpart primary ext4 14.5GiB 100% set 1 boot on

mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
mkfs.ext4 /dev/sda4

mount /dev/sda2 ${MOUNT_POINT}
mkdir ${MOUNT_POINT}/home
mount /dev/sda4 ${MOUNT_POINT}/home
mkdir ${MOUNT_POINT}/boot/efi -p
mount /dev/sda1 ${MOUNT_POINT}/boot/efi
swapon /dev/sda3
