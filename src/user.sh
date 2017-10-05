#!/usr/bin/env sh

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


# install nanum
curl -Lo ttf-nanum.tgz https://aur.archlinux.org/cgit/aur.git/snapshot/ttf-nanum.tar.gz
tar zxf ttf-nanum.tgz
cd ttf-nanum
address=`zsh -c 'source PKGBUILD; echo ${source[1]}'`
md5=`curl -s "${address}" | md5sum | awk '{print $1}'`
sed -Ei "s/md5sums=\('.+'\)/md5sums=('${md5}')/" PKGBUILD
makepkg -si --noconfirm
cd ..
rm -rf ttf-nanum ttf-nanum.tgz


sudo mount -o remount,size=4G /tmp


# for ncurses5-compat-libs that need to install clion
PGP_key=`curl -s https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD\?h\=ncurses5-compat-libs | sed -En "s/validpgpkeys=\('(.+)'\).*/\1/p"`
gpg --recv-keys ${PGP_key}

yaourt -S ncurses5-compat-libs

# install packages
yaourt -S jre8 jdk8 zsh-completions zsh-fast-syntax-highlighting-git zsh-fast-syntax-highlighting-git tilix \
 python2-nautilus openssh adobe-source-code-pro-fonts plank paper-icon-theme-git ttf-nanumgothic_coding --noconfirm

yaourt -S google-chrome chrome-gnome-shell-git slack-desktop intellij-idea-ultimate-edition linux-headers redshift \
 mendeleydesktop wine winetricks samba rust deluge-git clion --noconfirm


yaourt -R clion-jre intellij-idea-ultimate-edition-jre


# for zsh plugins
echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
echo 'source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh' >> ~/.zshrc


# for tilix
echo 'if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi' >> ~/.zshrc


# TODO: after first booting
# WINEARCH=win32 winetricks dotnet40 gdiplus msxml6 riched30 wmp9
# winetricks win7
# yaourt -S vmware-workstation flatplat-theme

for script in applications/*.sh; do
    sh ${script}
done