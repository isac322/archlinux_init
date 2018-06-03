#!/usr/bin/env sh

SCRIPT=`readlink -f "$0"`
BASEDIR=`dirname "$SCRIPT"`

dconf load /net/launchpad/plank/ < ${BASEDIR}/plank.conf