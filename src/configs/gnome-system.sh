#!/usr/bin/env sh

SCRIPT=`readlink -f "$0"`
BASEDIR=`dirname "$SCRIPT"`

dconf load /org/gnome/system/ < ${BASEDIR}/gnome-system.conf