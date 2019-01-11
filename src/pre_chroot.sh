#!/usr/bin/env sh

pacman -Sy pacman-contrib --noconfirm

# Select appropriate server
curl -s "https://www.archlinux.org/mirrorlist/?country=KR&country=US&protocol=http&protocol=https&ip_version=4&use_mirror_status=on" \
 | sed -e 's/^#Server/Server/' -e '/^#/d' \
 | rankmirrors -n 15 - > /etc/pacman.d/mirrorlist


pacstrap ${MOUNT_POINT} base base-devel zsh vim pacman-contrib

genfstab -U -p ${MOUNT_POINT} >> ${MOUNT_POINT}/etc/fstab
