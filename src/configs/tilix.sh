#!/usr/bin/env sh

SCRIPT=`readlink -f "$0"`
BASEDIR=`dirname "$SCRIPT"`

dconf load /com/gexperts/Tilix/ < ${BASEDIR}/tilix.conf