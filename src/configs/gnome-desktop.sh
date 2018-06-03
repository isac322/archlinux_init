#!/usr/bin/env sh

SCRIPT=`readlink -f "$0"`
BASEDIR=`dirname "$SCRIPT"`

dconf load /org/gnome/desktop/ < ${BASEDIR}/gnome-desktop.conf

sudo cp -av /usr/share/gnome-shell/gnome-shell-theme.gresource{,~}

GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
cd /usr/share/themes/${GTK_THEME}/gnome-shell
sudo glib-compile-resources --target=/usr/share/gnome-shell/gnome-shell-theme.gresource gnome-shell-theme.gresource.xml