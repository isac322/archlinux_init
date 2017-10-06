#!/usr/bin/env zsh

HOST_NAME='bhyoo-laptop'
USER_NAME='bhyoo'
MOUNT_POINT='/mnt'

SCRIPT=`readlink -f "$0"`
BASEDIR=`dirname "$SCRIPT"`

echo ${BASEDIR}

source "$BASEDIR"/partition.sh
source "$BASEDIR"/pre_chroot.sh

cp "$BASEDIR"/environment.sh "$BASEDIR"/user.sh ${MOUNT_POINT}
cp -r "$BASEDIR"/configs ${MOUNT_POINT}

arch-chroot ${MOUNT_POINT} env HOST_NAME=${HOST_NAME} USER_NAME=${USER_NAME} /environment.sh
arch-chroot ${MOUNT_POINT} su - "$USER_NAME" /user.sh

arch-chroot ${MOUNT_POINT} rm -rf /user.sh /environment.sh /configs

reboot
