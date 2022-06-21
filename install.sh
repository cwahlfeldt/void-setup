#! /bin/bash

# audio
xi alsa-utils
sudo touch /etc/asound.conf
sudo echo "defaults.pcm.card 1" >> /etc/asound.conf
sudo echo "defaults.pcm.device 0" >> /etc/asound.conf
sudo echo "defaults.ctl.card 1" >> /etc/asound.conf

# track pad
sudo echo "add_drivers+=\"bcm5974\"" > /etc/dracut.conf.d/10-touchpad.conf
sudo dracut --force

# fans
xi mbpfan
sudo ln -s /etc/sv/mbpfan /var/service
mbpfan -t

# lid hibernate
sudo ln -s /etc/sv/acpid /var/service

# powersave
xi thermald powertop
sudo ln -s /etcsv/thermald /var/service
sudo powertop -auto-tune

# microcode updates
sudo xbps-install -S intel-ucode
sudo xbps-reconfigure -f linux

# fun stuff
sudo xbps-install xorg-minimal dejavu-font-ttf xf86-video-intel
