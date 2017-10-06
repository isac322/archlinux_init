#!/usr/bin/env sh

SCRIPT=`readlink -f "$0"`
BASEDIR=`dirname "$SCRIPT"`

dconf load /org/gnome/gnome-system-monitor/ < ${BASEDIR}/gnome-system-monitor.conf