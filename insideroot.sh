# Setup locale and hostname
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
hwclock --systohc
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo "What hostname do you want?"
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1     localhost" > /etc/hosts
echo "::1     localhost" >> /etc/hosts
echo "127.0.1.1     $hostname.localdomain   $hostname" >> /etc/hosts
echo "--------------------------------------------------------"
#setup Ramdisk:
sed 's/HOOKS/#HOOKS/g' /etc/mkinitcpio.conf
echo "HOOKS=(base udev block filesystems keyboard fsck)" > /etc/mkinitcpio.conf
mkinitcpio -p linux
echo "--------------------------------------------------------"

# Setup network interface names to wlan0 and eth0 as default
ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules

# Limit Journaling:
echo "Storage=volatile" >> /etc/systemd/journald.conf
echo "SystemMaxUse=16M" >> /etc/systemd/journald.conf
sed 's/relatime/noatime/g' /etc/fstab
echo "--------------------------------------------------------"

# This might help things:
rm -f /var/lib/pacman/db.lck

# Install things...
pacman -Sy --noconfirm --needed pantheon-terminal xorg-server firefox lightdm lightdm-gtk-greeter cinnamon grub efibootmgr networkmanager code git openssh
echo "--------------------------------------------------------"

# Install boot loader
echo "What was the disk again?"
read disk2
echo "Drive for boot: $disk2"
grub-install --target=i386-pc --boot-directory /boot /dev/$disk2
grub-mkconfig -o /boot/grub/grub.cfg
echo "--------------------------------------------------------"

# Enable things
systemctl enable NetworkManager
systemctl enable lightdm
systemctl enable openssh
echo "--------------------------------------------------------"

# Install video drivers:
pacman -S --noconfirm --needed xf86-video-amdgpu xf86-video-ati xf86-video-intel xf86-video-nouveau xf86-video-vesa
echo "--------------------------------------------------------"

# Install laptop things:
pacman -S --noconfirm --needed xf86-input-synaptics acpi
echo "--------------------------------------------------------"

#Create root password
echo "Enter the root password: "
passwd

# Create user
echo "Enter username: "
read Username
useradd -m $Username
usermod -a -G wheel $Username
echo "%wheel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
echo "Enter $Username's Password:"
passwd $Username
# Finish up and Reboot:

##############
# SETUP ZSH? #
##############


echo "You have finished the script, please reboot the computer and log in!"
