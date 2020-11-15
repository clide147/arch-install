ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime

hwclock --systohc
pacman -S git
git clone https://github.com/m-bosman8596/arch-install

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

echo Archlinux > /etc/hostname
echo <<EOF > /etc/hosts
    127.0.0.1	localhost
    ::1	        localhost
    127.0.0.1	Archlinux.localdomain   Archlinux
EOF

pacman -S networkmanager
systemctl enable NetworkManager

echo "ROOT PASSWORD"
passwd

useradd -m -g users -G audio,video,network,wheel,storage,rfkill -s /bin/bash mitchell
echo "MITCHELL PASSWORD"
passwd mitchell
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers


pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

exit