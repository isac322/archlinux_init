#!/usr/bin/env bash

set -ex

timedatectl set-ntp true

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

# install oh-my-zsh

yay -S oh-my-zsh-git --noconfirm --removemake
cp /usr/share/oh-my-zsh/zshrc ~/.zshrc

# set oh-my-zsh plugins
sed -Ei -e 's/^(ZSH_THEME=.+)$/#\1/' ~/.zshrc
perl -i -0777 -pe 's/plugins=\(\n.+\n\)/plugins=(colored-man-pages colorize command-not-found extract sudo vundle docker git npm pip python virtualenv archlinux systemd bgnotify cargo common-aliases dircycle docker-compose jsontools rust ufw urltools)/g' ~/.zshrc

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
  zsh-completions zsh-autosuggestions zsh-fast-syntax-highlighting-git zsh-theme-powerlevel10k-git zsh-history-search-multi-word-git zsh-you-should-use \
  tilix exfat-dkms-git python-nautilus openssh \
  adobe-source-code-pro-fonts ttf-fira-code nerd-fonts-dejavu-complete ttf-symbola ttf-nanum ttf-nanumgothic_coding \
  python-pip vundle htop plank paper-icon-theme-git materia-gtk-theme --noconfirm --removemake

# for hardware acceleration
yay -S intel-media-driver libva-utils vulkan-intel vdpauinfo libvdpau-va-gl --noconfirm --removemake

yay -S chromium-vaapi-bin chrome-gnome-shell slack-desktop mpv-mpris \
  intellij-idea-ultimate-edition intellij-idea-ultimate-edition-jre clion clion-jre \
  wine-staging winetricks rustup deluge vmware-workstation --noconfirm --removemake
yay -S cmake gdb chromium-widevine pepper-flash --asdeps --noconfirm --removemake

yay -S gnome-shell-extension-system-monitor-git gnome-shell-extension-workspaces-to-dock \
  gnome-shell-extension-topicons-plus-git gnome-shell-extension-no-topleft-hot-corner \
  gnome-shell-extension-dynamic-top-bar-git gnome-shell-extension-autohide-battery --noconfirm --removemake

curl -o .p10k.zsh https://gist.githubusercontent.com/isac322/641c89f4db32c3f73dc8a3eb267417f3/raw/.p10k.zsh

tee -a ~/.zshrc > /dev/null << END

# for zsh plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/history-search-multi-word/history-search-multi-word.plugin.zsh
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# for tilix
if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
	source /etc/profile.d/vte.sh
fi

# To customize prompt, run \`p10k configure\` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
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
