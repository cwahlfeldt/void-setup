#! /bin/bash

# first steps:
# login as root
# groupadd sudo
# visudo -> uncomment sudo group
# usermod -a -G sudo waffles
# reboot and log in as waffles and run this script

cd ~/

# sudo wpa_passphrase "waffleiron" "Danzig@708" >> /etc/wpa_supplicant/wpa_supplicant.conf
# sudo wpa_supplicant -B - i wlp0s20u1 -c /etc/wpa_supplicant/wpa_supplicant.conf
# sudo ln -s /etc/sv/wpa_supplicant /var/service/
#
# sleep 20

# sudo xbps-install -Sy git

git clone https://github.com/void-linux/void-packages.git
cd void-packages
./xbps-src binary-bootstrap
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf

./xbps-src pkg xtools
sudo xbps-install -y --repository=hostdir/binpkgs xtools

./xbps-src pkg intel-ucode
sudo xbps-install -y --repository=hostdir/binpkgs/nonfree intel-ucode
sudo xbps-reconfigure -f linux

cd ~/

# audio
sudo xbps-install -Sy alsa-utils
sudo touch /etc/asound.conf
sudo echo "defaults.pcm.card 1" >> /etc/asound.conf
sudo echo "defaults.pcm.device 0" >> /etc/asound.conf
sudo echo "defaults.ctl.card 1" >> /etc/asound.conf
sudo ln -s /etc/sv/alsa /var/service/

# track pad
sudo touch /etc/dracut.conf.d/10-touchpad.conf
sudo echo "add_drivers+=\"bcm5974\"" > /etc/dracut.conf.d/10-touchpad.conf
sudo dracut --force

# fans
sudo xbps-install -Sy mbpfan
sudo ln -s /etc/sv/mbpfan /var/service/
mbpfan -t

# lid hibernate
sudo ln -s /etc/sv/acpid /var/service/

# powersave
sudo xbps-install -Sy thermald powertop
sudo ln -s /etc/sv/thermald /var/service/
sudo powertop -auto-tune

# fun stuff
sudo xbps-install -Sy \
    i3-gaps \
    zsh \
    base-devel \
    xorg-server \
    xorg-minimal \
    xinit \
    xf86-video-intel \
    xf86-input-libinput \
    picom \
    noto-fonts-ttf \
    nerd-fonts-ttf \
    font-awesome \
    firefox \
    qutebrowser \
    kitty \
    feh \
    dbus \
    iwd \
    dmenu \
    exa

touch ~/.zshrc
echo "HISTFILE=~/.histfile" >> ~/.zshrc
echo "HISTSIZE=1000" >> ~/.zshrc
echo "SAVEHIST=1000" >> ~/.zshrc
echo "zstyle :compinstall filename '/home/waffles/.zshrc'"
echo "autoload -Uz compinit promptinit" >> ~/.zshrc
echo "compinit" >> ~/.zshrc
chsh -s /bin/zsh

sudo xbps-install -Sy nodejs-lts
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
source ~/.bash_profile
echo "export PATH=~/.npm-global/bin:$PATH" >> ~/.zshrc

mkdir -p ~/.config/kitty
touch ~/.config/kitty/kitty.conf
echo "font_family Fira Code Regular Nerd Font Complete" >> ~/.config/kitty/kitty.conf
echo "font_size 10" >> ~/.config/kitty/kitty.conf

mkdir -p ~/.config/nvim

mkdir -p ~/.config/picom
sudo cp -rf ~/usr/share/examples/picom/picom.sample.conf ~/.config/picom/picom.conf

mkdir ~/.xinitrc
echo "picom -b" >> ~/.xinitrc
echo "exec i3" >> ~/.xinitrc
