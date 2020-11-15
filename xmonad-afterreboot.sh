sudo pacman -Syu

sudo pacman -S xorg-server xorg-apps xorg-xinit xterm

sudo pacman -S lightdm

sudo pacman -S lightdm-gtk-greeter lightdm-gtk-greeter-settings

sudo systemctl enable lightdm.service

reboot