#!/usr/bin/env sh

# Select appropriate server
curl -fsSLo mirrorlist https://www.archlinux.org/mirrorlist/\?country\=KR\&protocol\=http\&protocol\=https\&ip_version\=4\&ip_version\=6\&use_mirror_status\=on
sed -i 's/^#\W*Server/Server/' mirrorlist
rankmirrors mirrorlist > /etc/pacman.d/mirrorlist
rm mirrorlist


pacstrap ${MOUNT_POINT} base base-devel zsh vim

genfstab -U -p ${MOUNT_POINT} >> ${MOUNT_POINT}/etc/fstab
