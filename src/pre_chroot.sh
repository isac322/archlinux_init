#!/usr/bin/env sh

set -ex

timedatectl set-ntp true
pacman -Sy pacman-contrib --noconfirm

# Select appropriate server
curl -SsL "https://www.archlinux.org/mirrorlist/?country=KR&country=US&protocol=http&protocol=https&ip_version=4&use_mirror_status=on" \
  | sed -e 's/^#Server/Server/' -e '/^#/d' \
  | rankmirrors -n 15 - > /etc/pacman.d/mirrorlist

pacstrap "${MOUNT_POINT}" base base-devel linux linux-firmware zsh vim pacman-contrib

genfstab -U -p "${MOUNT_POINT}" >> "${MOUNT_POINT}"/etc/fstab
