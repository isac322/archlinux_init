#!/usr/bin/env sh

pacman -Sy pacman-contrib --noconfirm

# Select appropriate server
curl -fsSLo mirrorlist https://www.archlinux.org/mirrorlist/\?country\=KR
sed -i 's/^#\W*Server/Server/' mirrorlist
rankmirrors mirrorlist > /etc/pacman.d/mirrorlist
rm mirrorlist


pacstrap ${MOUNT_POINT} base base-devel zsh vim

genfstab -U -p ${MOUNT_POINT} >> ${MOUNT_POINT}/etc/fstab
