#!/usr/bin/env sh

set -ex

HOST_NAME='bhyoo-laptop'
USER_NAME='bhyoo'
MOUNT_POINT='/mnt'

EFI_PARTITION='/dev/sda1'
ROOT_PARTITION='/dev/sda2'
HOME_PARTITION='/dev/sda3'
SWAP_PARTITION='/dev/sda4'

SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")

echo "${BASEDIR}"

. "$BASEDIR"/partition.sh
. "$BASEDIR"/pre_chroot.sh

cp "$BASEDIR"/environment.sh "$BASEDIR"/user.sh ${MOUNT_POINT}
cp -r "$BASEDIR"/configs ${MOUNT_POINT}
chmod 755 ${MOUNT_POINT}/user.sh ${MOUNT_POINT}/environment.sh ${MOUNT_POINT}/configs/*.sh

arch-chroot ${MOUNT_POINT} env HOST_NAME=${HOST_NAME} USER_NAME=${USER_NAME} SWAP_PARTITION=${SWAP_PARTITION} /environment.sh
arch-chroot ${MOUNT_POINT} su - "${USER_NAME}" /user.sh

arch-chroot ${MOUNT_POINT} rm -rf /user.sh /environment.sh /configs

reboot
