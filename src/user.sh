#!/usr/bin/env sh

timedatectl set-ntp true

# install oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# FIXME: doesn't work
# set oh-my-zsh plugins
sed -Ei \
 -e 's/plugins=\([^)]+\)/plugins=(git npm jsontools sudo docker pip python archlinux virtualenv)/' \
 -e 's/ZSH_THEME="[^"]+"/ZSH_THEME="agnoster"/' ~/.zshrc


# install aurman
git clone https://aur.archlinux.org/aurman.git
cd aurman
makepkg -fsri --noconfirm
cd ..
rm -rf aurman

echo 'export VISUAL="vim"' >> ~/.zshrc



sudo mount -o remount,size=4G /tmp


# install packages
aurman -S jdk zsh-completions zsh-autosuggestions zsh-fast-syntax-highlighting-git tilix-bin exfat-dkms-git \
 openssh adobe-source-code-pro-fonts powerline-fonts ttf-symbola ttf-nanum ttf-nanumgothic_coding \
 vundle htop plank paper-icon-theme-git  materia-gtk-theme --noconfirm

# for hardware acceleration
aurman -S libva-intel-driver libva-utils vulkan-intel vdpauinfo libvdpau-va-gl --noconfirm


aurman -S google-chrome chrome-gnome-shell slack-desktop intellij-idea-ultimate-edition \
 mendeleydesktop wine-staging winetricks rustup deluge-git clion --noconfirm

aurman -S gnome-shell-extension-system-monitor-git gnome-shell-extension-workspaces-to-dock \
 gnome-shell-extension-topicons-plus gnome-shell-extension-no-topleft-hot-corner \
 gnome-shell-extension-dynamic-top-bar gnome-shell-extension-autohide-battery-git --noconfirm


aurman -R clion-cmake clion-gdb --noconfirm


# for zsh plugins
echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
echo 'source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh' >> ~/.zshrc
echo 'source /usr/share/doc/pkgfile/command-not-found.zsh' >> ~/.zshrc


# for tilix
tee -a ~/.zshrc > /dev/null << END
if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi
END


# remove unused packages
aurman -Rsn `aurman -Qdtq` --noconfirm


mkdir ~/.config/autostart/ -p

# ready for next boot
tee ~/.config/autostart/init.desktop > /dev/null << END
[Desktop Entry]
Name=Init
Type=Application
Exec=tilix -e sh /home/$USER/init.sh
END

cp -r /configs ~/
tee ~/init.sh > /dev/null << END
#!/usr/bin/env bash
for script in ~/configs/*.sh; do
    sh ${script}
done

# for ncurses5-compat-libs that need to install vmware-workstation
PGP_key=`curl -s https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD\?h\=ncurses5-compat-libs | sed -En "s/validpgpkeys=\('(.+)'\).*/\1/p"`
gpg --recv-keys ${PGP_key}
aurman -S vmware-workstation --noconfirm

winecfg

rm ~/init.sh ~/.config/autostart/init.desktop
rm -rf ~/configs

sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl enable vmware-networks.service vmware-usbarbitrator.service
echo "mks.gl.allowBlacklistedDrivers = TRUE" > ~/.vmware/preferences
END
