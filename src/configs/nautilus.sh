#!/usr/bin/env sh

SCRIPT=`readlink -f "$0"`
BASEDIR=`dirname "$SCRIPT"`

dconf load /org/gnome/nautilus/ < ${BASEDIR}/nautilus.conf