#!/usr/bin/env bash

print_sep() {
	echo '#####################################################################################################################'
}

sed -Ei "s/#?\s*MAKEFLAGS=.+/MAKEFLAGS=\"-j$(nproc)\"/" /etc/makepkg.conf
timedatectl set-ntp true

echo "$HOST_NAME" > /etc/hostname
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime


# Select appropriate locale
locales=('en_US.UTF-8' 'ko_KR.UTF-8')

for locale in ${locales[@]}; do
	sed -ri "s/#(${locale}.*)/\1/" /etc/locale.gen
done
echo 'LANG=ko_KR.UTF-8' > /etc/locale.conf
locale-gen


# enable multilib
perl -i -0777 -pe 's/#\s*\[multilib\]\n#\s*(.+)/[multilib]\n\1/g' /etc/pacman.conf
pacman -Syu

# colorize pacman
sed -Ei -e 's/#Color/Color/' /etc/pacman.conf


chsh -s `which zsh`
print_sep
echo 'setting password of root'
passwd

# for hibernate
sed -Ei 's/HOOKS=(.+)udev(.+)/HOOKS=\1udev resume\2/' /etc/mkinitcpio.conf
mkinitcpio -p linux


pacman -S grub efibootmgr os-prober intel-ucode --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=archlinux
# add useful entries to grub
tee -a /etc/grub.d/40_custom > /dev/null << END

menuentry "System shutdown" {
	echo "System shutting down..."
	halt
}

menuentry "System restart" {
	echo "System rebooting..."
	reboot
}

menuentry "Firmware setup" {
	fwsetup
}
END
# add resume point to swap partition
SWAP_UUID=`blkid ${SWAP_PARTITION} | sed -E 's/.*\s+UUID="([^"]+)".*/\1/'`
sed -Ei "s/GRUB_CMDLINE_LINUX_DEFAULT=\"(.+)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 resume=UUID=${SWAP_UUID}\"/" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg


useradd -m -g users -G storage,power,wheel -s /bin/zsh ${USER_NAME}
sed -Ei 's/#\s+%wheel\s+ALL=\(ALL\)\s+ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
print_sep
echo "setting password of ${USER_NAME}"
passwd "${USER_NAME}"

pacman -R vi --noconfirm
ln -s /usr/bin/vim /usr/bin/vi


pacman -S git bluez bluez-utils unrar pkgfile pigz sshfs most linux-headers redshift \
 ntfs-3g samba xorg-server xorg-xinit --noconfirm
pkgfile --update

# optimize makepkg
sed -Ei "s/PKGEXT=.+/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
sed -Ei "s/COMPRESSGZ\s*=\s*\(\s*(\S+)\s+([^)]+)\)/COMPRESSGZ=(pigz \2)/" /etc/makepkg.conf
sed -Ei "s/COMPRESSXZ\s*=\s*\((.+)\)/COMPRESSXZ=(\1 --threads=0)/" /etc/makepkg.conf

# install xorg graphic driver
print_sep
echo "Your device : $(lspci | grep -e VGA -e 3D)"
print_sep
echo "DRIVER LIST"
pacman -Ss xf86-video
print_sep
printf 'enter your full driver name : '
read driver

pacman -S ${driver} --noconfirm
if [ $? -ne 0 ]; then
	pacman -S xorg-drivers --noconfirm
fi

# for trackpoint scroll (Dell Latitude 7490 only)
tee /etc/X11/xinit/xinitrc.d/99-trackpoint-scroll.sh > /dev/null << END
#!/usr/bin/env sh

xinput set-prop "DELL081C:00 044E:121F Mouse" "libinput Scroll Method Enabled" 0 0 1
xinput set-prop "DELL081C:00 044E:121F Mouse" "libinput Accel Speed" -0.4
END
chmod +x /etc/X11/xinit/xinitrc.d/99-trackpoint-scroll.sh

# install desktop
pacman -S baobab eog eog-plugins evince gdm gnome-calculator gnome-control-center gnome-disk-utility gnome-font-viewer \
 gnome-keyring gnome-screenshot gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor \
 gucharmap gvfs gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb mousetweaks nautilus \
 networkmanager totem gst-libav vino xdg-user-dirs-gtk cheese dconf-editor file-roller gedit gnome-logs gnome-mines \
 gnome-sound-recorder gnome-tweak-tool gnome-video-effects seahorse vinagre gparted meld ttf-ubuntu-font-family \
 gst-plugins-ugly fcitx-configtool fcitx-hangul fcitx-gtk3 xorg-xinput --noconfirm


# for printer support
pacman -S cups system-config-printer --noconfirm
systemctl enable org.cups.cupsd.service

# enable fcitx
tee /etc/X11/xinit/xinitrc.d/60-fctix.sh > /dev/null << END
#!/usr/bin/env sh

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
END
chmod +x /etc/X11/xinit/xinitrc.d/60-fctix.sh

# enable auto connection of bluetooth
tee /etc/pulse/default.pa > /dev/null << END
# automatically switch to newly-connected devices
load-module module-switch-on-connect
END
sed -E 's/^#?AutoEnable=(true|false)/AutoEnable=true/' /etc/bluetooth/main.conf

systemctl enable NetworkManager
systemctl enable gdm
systemctl enable bluetooth.service

# gnome (2017-10-03)
#9 gnome-calculator
#11 gnome-control-center
#13 gnome-disk-utility
#14 gnome-font-viewer
#15 gnome-keyring
#16 gnome-screenshot
#18 gnome-settings-daemon
#19 gnome-shell
#20 gnome-shell-extensions
#21 gnome-system-monitor
#28 gucharmap
#29 gvfs
#30 gvfs-afc
#31 gvfs-goa
#32 gvfs-google
#34 gvfs-mtp
#35 gvfs-nfs
#36 gvfs-smb
#37 mousetweaks
#39 nautilus
#40 networkmanager
#41 totem
#44 vino
#45 xdg-user-dirs-gtk


# gnome-extra (2017-10-03)
#7 cheese
#8 dconf-editor
#11 file-roller
#14 gedit
#29 gnome-logs
#32 gnome-mines
#38 gnome-sound-recorder
#42 gnome-todo
#43 gnome-tweak-tool
#54 seahorse
#57 vinagre
