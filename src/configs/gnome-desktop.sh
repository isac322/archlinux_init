#!/usr/bin/env sh

SCRIPT=`readlink -f "$0"`
BASEDIR=`dirname "$SCRIPT"`

dconf load /org/gnome/desktop/ < ${BASEDIR}/gnome-desktop.conf


GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
sudo cp --backup /usr/share{/themes/${GTK_THEME},}/gnome-shell/gnome-shell-theme.gresource