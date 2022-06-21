#! /bin/bash

# audio
sudo xbps-install alsa-utils
sudo touch /etc/asound.conf
sudo echo "defaults.pcm.card 1" >> /etc/asound.conf
sudo echo "defaults.pcm.device 0" >> /etc/asound.conf
sudo echo "defaults.ctl.card 1" >> /etc/asound.conf

# track pad
sudo echo "add_drivers+=\"bcm5974\"" > /etc/dracut.conf.d/10-touchpad.conf
sudo dracut --force

# fans
sudo xbps-install -S mbpfan
sudo ln -s /etc/sv/mbpfan /var/service/
mbpfan -t

# lid hibernate
sudo ln -s /etc/sv/acpid /var/service/

# powersave
sudo xbps-install -S thermald powertop
sudo ln -s /etcsv/thermald /var/service
sudo powertop -auto-tune

# microcode updates
cd ~/void-packages
./void-packages pkg intel-ucode
sudo xbps-install --repository=hostdir/binpkgs/nonfree intel-ucode
sudo xbps-reconfigure -f linux
cd ~/

# fun stuff
sudo xbps-install -S \
    base-devel \
    xorg-server \
    xorg-minimal \
    xinit \
    xf86-video-intel \
    xf86-input-libinput \
    picom \
    dejavu-font-ttf \
    noto-fonts-ttf \
    nerd-fonts-ttf \
    font-awesome \
    firefox \
    qutebrowser \
    kitty \
    feh \
    dmenu \
    exa

sudo xbps-install -S nodejs-lts
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
# Add to .bash_profile
export PATH=~/.npm-global/bin:$PATH
source ~/.bash_profile

sudo ln -sf /etc/sv/alsa /var/service
sudo ln -sf /etc/sv/dbus /var/service


