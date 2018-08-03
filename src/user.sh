#!/usr/bin/env bash

timedatectl set-ntp true

# install oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# set oh-my-zsh plugins
sed -Ei -e 's/ZSH_THEME="[^"]+"/ZSH_THEME="powerlevel9k/powerlevel9k"/' ~/.zshrc
perl -i -0777 -pe 's/plugins=\(\n.+\n\)/plugins=(git npm jsontools sudo docker pip python archlinux virtualenv)/g' ~/.zshrc


# install aurman
git clone https://aur.archlinux.org/aurman.git
cd aurman
makepkg -fsri --noconfirm
cd ..
rm -rf aurman

echo 'export VISUAL="vim"' >> ~/.zshrc

# for touchpad gesture
aurman -S libinput-gestures --noconfirm
libinput-gestures-setup autostart
libinput-gestures-setup start
sudo gpasswd -a ${USER_NAME} input

# for fingerprint
# aurman -S fingerprint-gui --noconfirm

# for SmartCardReader (run pcsc_scan for test)
aurman -S ccid opensc pcsc-tools --noconfirm
# auto start SmartCardReader service
sudo systemctl enable pcscd.service



sudo mount -o remount,size=4G /tmp


# install packages
aurman -S jdk zsh-completions zsh-autosuggestions zsh-fast-syntax-highlighting-git tilix-bin exfat-dkms-git \
 python-nautilus openssh adobe-source-code-pro-fonts powerline-fonts ttf-symbola ttf-nanum ttf-nanumgothic_coding \
 python-pip vundle htop plank paper-icon-theme-git materia-gtk-theme zsh-theme-powerlevel9k \
 zsh-history-search-multi-word-git alias-tips-git --noconfirm

# link powerlevel9k theme to oh-my-zsh
ln -s /usr/share/zsh-theme-powerlevel9k ~/.oh-my-zsh/custom/themes/powerlevel9k

# for hardware acceleration
aurman -S libva-intel-driver libva-utils vulkan-intel vdpauinfo libvdpau-va-gl --noconfirm


aurman -S google-chrome chrome-gnome-shell slack-desktop \
 intellij-idea-ultimate-edition intellij-idea-ultimate-edition-jre clion clion-jre \
 mendeleydesktop wine-staging winetricks rustup deluge-git --noconfirm

aurman -S gnome-shell-extension-system-monitor-git gnome-shell-extension-workspaces-to-dock \
 gnome-shell-extension-topicons-plus gnome-shell-extension-no-topleft-hot-corner \
 gnome-shell-extension-dynamic-top-bar gnome-shell-extension-autohide-battery-git --noconfirm


# for zsh plugins
echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
echo 'source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh' >> ~/.zshrc
echo 'source /usr/share/doc/pkgfile/command-not-found.zsh' >> ~/.zshrc
echo 'source /usr/share/zsh/plugins/history-search-multi-word/history-search-multi-word.plugin.zsh' >> ~/.zshrc
echo 'source /usr/share/zsh/plugins/alias-tips/alias-tips.plugin.zsh' >> ~/.zshrc


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
Exec=tilix -e sh /home/\$USER/init.sh
END

cp -r /configs ~/
tee ~/init.sh > /dev/null << END
#!/usr/bin/env bash
for script in ~/configs/*.sh; do
    sh \${script}
done

# for ncurses5-compat-libs that need to install vmware-workstation
PGP_key=`curl -s https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD\?h\=ncurses5-compat-libs | sed -En "s/validpgpkeys=\('(.+)'\).*/\1/p"`
gpg --recv-keys \${PGP_key}
aurman -S vmware-workstation --noconfirm

winecfg

rm ~/init.sh ~/.config/autostart/init.desktop
rm -rf ~/configs

sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl enable vmware-networks.service vmware-usbarbitrator.service
echo "mks.gl.allowBlacklistedDrivers = TRUE" > ~/.vmware/preferences
END
