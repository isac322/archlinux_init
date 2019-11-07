#!/usr/bin/env bash

set -ex

timedatectl set-ntp true

# install oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# set oh-my-zsh plugins
sed -Ei -e 's/ZSH_THEME="[^"]+"/ZSH_THEME="powerlevel9k\/powerlevel9k"/' ~/.zshrc
perl -i -0777 -pe 's/plugins=\(\n.+\n\)/plugins=(git npm jsontools sudo docker pip python archlinux virtualenv systemd)/g' ~/.zshrc


# install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -cirs --noconfirm
cd ..
rm -rf yay

echo 'export VISUAL="vim"' >> ~/.zshrc

# for touchpad gesture
yay -S libinput-gestures --noconfirm --removemake
libinput-gestures-setup autostart
libinput-gestures-setup start
sudo gpasswd -a "${USER_NAME}" input

# for fingerprint
# yay -S fingerprint-gui --noconfirm --removemake

# for SmartCardReader (run pcsc_scan for test)
yay -S ccid opensc pcsc-tools --noconfirm --removemake
# auto start SmartCardReader service
sudo systemctl enable pcscd.service



tmp_size=$(df --output=avail /tmp | tail -1)
if [[ ${tmp_size} -lt 4194304 ]]; then
	sudo mount -o remount,size=4G /tmp
fi


# install packages
yay -S jdk \
 zsh-completions zsh-autosuggestions zsh-fast-syntax-highlighting-git zsh-theme-powerlevel9k zsh-history-search-multi-word-git alias-tips-git \
 tilix exfat-dkms-git python-nautilus openssh \
 adobe-source-code-pro-fonts powerline-fonts ttf-symbola ttf-nanum ttf-nanumgothic_coding \
 python-pip vundle htop plank paper-icon-theme-git materia-gtk-theme --noconfirm --removemake

# link powerlevel9k theme to oh-my-zsh
ln -s /usr/share/zsh-theme-powerlevel9k ~/.oh-my-zsh/custom/themes/powerlevel9k

# for hardware acceleration
yay -S intel-media-driver libva-utils vulkan-intel vdpauinfo libvdpau-va-gl --noconfirm --removemake


yay -S chromium-vaapi-bin chrome-gnome-shell slack-desktop mpv-mpris \
 intellij-idea-ultimate-edition intellij-idea-ultimate-edition-jre clion clion-jre \
 mendeleydesktop wine-staging winetricks rustup deluge-python3-git vmware-workstation --noconfirm --removemake
yay -S cmake gdb chromium-widevine pepper-flash --asdep --noconfirm --removemake

yay -S gnome-shell-extension-system-monitor-git gnome-shell-extension-workspaces-to-dock-git \
 gnome-shell-extension-topicons-plus-git gnome-shell-extension-no-topleft-hot-corner \
 gnome-shell-extension-dynamic-top-bar-git gnome-shell-extension-autohide-battery-git --noconfirm --removemake


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
yay -Rsn "$(yay -Qdtq)" --noconfirm --removemake


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

winecfg

rm ~/init.sh ~/.config/autostart/init.desktop
rm -rf ~/configs

sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl enable vmware-networks.service vmware-usbarbitrator.service
echo "mks.gl.allowBlacklistedDrivers = TRUE" > ~/.vmware/preferences
END
