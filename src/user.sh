#!/usr/bin/env sh

# install oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# install fast-syntax-highlighting
git clone https://github.com/zdharma/fast-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/fast-syntax-highlighting

# set oh-my-zsh plugins
sed -Ei -e 's/plugins=\([^)]+\)/plugins=(git npm jsontools sudo docker pip python archlinux fast-syntax-highlighting)/' \
 -e 's/ZSH_THEME="[^"]+"/ZSH_THEME="agnoster"/' ~/.zshrc

# for tilix
echo 'if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi' >> ~/.zshrc

# for zsh-completions
echo 'source /usr/share/zsh/plugins/zsh-completions/zsh-completions.zsh' >> ~/.zshrc


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
sed -E "s/md5sums=\('.+'\)/md5sums=('${md5}')/" PKGBUILD
makepkg -si --noconfirm
cd ..
rm -rf ttf-nanum ttf-nanum.tgz


sudo mount -o remount,size=4G /tmp

# install packages
yaourt -S jre8 jdk8 zsh-completions tilix python2-nautilus openssh adobe-source-code-pro-fonts \
 plank paper-icon-theme-git flatplat-theme ttf-nanumgothic_coding --noconfirm
yaourt -S google-chrome chrome-gnome-shell-git slack-desktop intellij-idea-ultimate-edition linux-headers redshift \
 vmware-workstation mendeleydesktop wine winetricks samba rust --noconfirm

# WINEARCH=win32 winetricks dotnet40 gdiplus msxml6 riched30 wmp9
# winetricks win7

for script in applications/*.sh; do
    sh ${script}
done