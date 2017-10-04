#!/usr/bin/env sh

gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface cursor-theme 'Paper'
gsettings set org.gnome.desktop.interface gtk-theme 'Flat-Plat'
gsettings set org.gnome.desktop.interface icon-theme 'Paper'
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,close'

GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
sudo cp --backup /usr/share{/themes/${GTK_THEME},}/gnome-shell/gnome-shell-theme.gresource