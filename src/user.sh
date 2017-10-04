#!/usr/bin/env sh

# install oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# setting zsh plugin
# git clone git://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

sed -Ei -e 's/plugins=\([^)]+\)/plugins=(git npm jsontools sudo docker pip python zsh-syntax-highlighting zsh-autosuggestions archlinux)/' \
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
sed -E "s/md5sums=\('.+'\)/md5sums=('${md5}')/" PKGBUILD
makepkg -si
cd ..
rm -rf ttf-nanum

sudo mount -o remount,size=4G /tmp

# install packages
yaourt -S jre8 jdk8 zsh-completions zsh-syntax-highlighting tilix openssh adobe-source-code-pro-fonts plank \
 paper-icon-theme-git flatplat-theme --noconfirm
yaourt -S google-chrome vlc slack-desktop intellij-idea-ultimate-edition clion redshift vmware-workstation \
 mendeleydesktop wine-staging winetricks --noconfirm

WINEARCH=win32 winetricks gdiplus msxml6 riched30 wp9

# etc.
#ttf-nanum ttf-nanumgothic_coding
# 1de7736a48dfaed5eb70ca2c4ce315b9
