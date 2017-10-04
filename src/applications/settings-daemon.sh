#!/usr/bin/env sh

gsettings set org.gnome.settings-daemon.peripherals.keyboard numlock-state 'on'

dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'tilix'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Primary><Alt>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'tilix'"

dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name "'tilix quake'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding "'F10'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command "'tilix --quake'"

dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/name "'monitor'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/binding "'<Primary><Alt>m'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/command "'gnome-system-monitor'"

dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/name "'nautilus'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/binding "'<Super>e'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/command "'nautilus'"

dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/name "'gedit'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/binding "'<Primary><Alt>e'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/command "'gedit'"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/']"