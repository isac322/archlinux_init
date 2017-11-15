#!/usr/bin/env sh

timedatectl set-ntp true

# install oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# set oh-my-zsh plugins
sed -Ei -e 's/plugins=\([^)]+\)/plugins=(git npm jsontools sudo docker pip python archlinux)/' \
 -e 's/ZSH_THEME="[^"]+"/ZSH_THEME="agnoster"/' ~/.zshrc


# install yaourt
git clone https://aur.archlinux.org/package-query.git
cd package-query
makepkg -si --noconfirm
cd ..
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
makepkg -si --noconfirm
cd ..

rm -rf package-query yaourt

echo 'export VISUAL="vim"' >> ~/.zshrc



sudo mount -o remount,size=4G /tmp


# for ncurses5-compat-libs that need to install clion
PGP_key=`curl -s https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD\?h\=ncurses5-compat-libs | sed -En "s/validpgpkeys=\('(.+)'\).*/\1/p"`
gpg --recv-keys ${PGP_key}

yaourt -S ncurses5-compat-libs --noconfirm

# install packages
yaourt -S jre8 jdk8 zsh-completions zsh-autosuggestions zsh-fast-syntax-highlighting-git pm-utils tilix exfat-utils \
 python2-nautilus openssh adobe-source-code-pro-fonts plank paper-icon-theme-git ttf-nanumgothic_coding materia-theme \
 powerline-fonts ttf-nanum --noconfirm

yaourt -S google-chrome chrome-gnome-shell-git slack-desktop intellij-idea-ultimate-edition \
 mendeleydesktop wine winetricks rust deluge-git clion --noconfirm

yaourt -S gnome-shell-extension-system-monitor-git gnome-shell-extension-workspaces-to-dock-git \
 gnome-shell-extension-topicons-plus-git gnome-shell-extension-no-topleft-hot-corner \
 gnome-shell-extension-mediaplayer-git gnome-shell-extension-dynamic-top-bar \
 gnome-shell-extension-autohide-battery-git --noconfirm


yaourt -R clion-jre intellij-idea-ultimate-edition-jre clion-cmake --noconfirm
gpg --delete-keys ${PGP_key}


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


# TODO: after first booting
# WINEARCH=win32 winetricks dotnet40 gdiplus msxml6 riched30 wmp9
# winetricks win7
# yaourt -S vmware-workstation


# remove unused packages
yaourt -Rsn `yaourt -Qdtq` --noconfirm


mkdir ~/.config/autostart/ -p

# ready for next boot
tee ~/.config/autostart/init.desktop > /dev/null << END
[Desktop Entry]
Name=Init
Type=Application
Exec=tilix -e sh /home/$USER/init.sh
END

cp -r /configs ~/

echo '#!/usr/bin/env sh
for script in ~/configs/*.sh; do
    sh ${script}
done
yaourt -S vmware-workstation --noconfirm
winecfg
rm ~/init.sh ~/.config/autostart/init.desktop
rm -rf ~/configs
sudo grub-mkconfig -o /boot/grub/grub.cfg' > ~/init.sh
