#!/usr/bin/env sh

set -ex

#parted -s /dev/sda mklabel gpt mkpart ESP fat32 1% 513MiB mkpart primary ext4 513MiB 10.5GiB \
# mkpart primary linux-swap 10.5GiB 14.5GiB mkpart primary ext4 14.5GiB 100% set 1 boot on

mkfs.fat -F32 "${EFI_PARTITION}"
mkfs.ext4 "${ROOT_PARTITION}"
mkfs.ext4 "${HOME_PARTITION}"
mkswap "${SWAP_PARTITION}"

mount "${ROOT_PARTITION}" "${MOUNT_POINT}"
mkdir "${MOUNT_POINT}"/home
mount "${HOME_PARTITION}" "${MOUNT_POINT}"/home
mkdir "${MOUNT_POINT}"/boot/efi -p
mount "${EFI_PARTITION}" "${MOUNT_POINT}"/boot/efi
swapon "${SWAP_PARTITION}"
