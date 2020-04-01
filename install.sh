# set time and date
timedatectl set-ntp true

# Make partitions.
echo "Select disk (sda or sdb):"
read disk
sgdisk --zap-all /dev/$disk                     # Erase everything
sgdisk -n 0:0:+10MiB -t 0:ef02 /dev/$disk       # Bios Boot
sgdisk -n 0:0:+500Mib -t 0:ef00 /dev/$disk      # EFI partition
sgdisk -n 0:0:0 -t 0:8300 /dev/$disk            # Linux
sgdisk -p /dev/$disk                            # List partitions, just in case.

# Format drives.
mkfs.fat -F32 /dev/$disk2
mkfs.ext4 /dev/$disk3

# Mount.
mkdir -p /mnt/usb
mount /dev/$disk3 /mnt/usb
mkdir /mnt/usb/boot
mount /dev/$disk2 /mnt/usb/boot

# Install base system.
pacstrap /mnt/usb linux linux-firmware base base-devel nano pantheon-terminal xorg-server lightdm cinnamon grub efibootmgr networkmanager

# Use labels instead of UUIDs
genfstab -U /mnt/usb > /mnt/usb/etc/fstab

# enter system as root
arch-chroot /mnt/usb

# Setup locale and hostname
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
hwclock -systohc
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale.gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo "What hostname do you want?"
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1     localhost" >> /etc/hosts
echo "127.0.1.1     $hostname.localdomain   $hostname" >> /etc/hosts

#setup Ramdisk:
echo "HOOKS=(base udev block filesystems keyboard fsck)" > /etc/mkinitcpio.conf
mkinitcpio -p linux

# Setup network interface names to wlan0 and eth0 as default
ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules

# Limit Journaling:
echo "Storage=volatile" >> /etc/systemd/journald.conf
echo "SystemMaxUse=16M" >> /etc/systemd/journald.conf
sed 's/relatime/noatime/g' /etc/fstab

# Install boot loader
grub-install --target=i386-pc --boot-directory /boot /dev/$disk
grub-mkconfig -o /boot/grub/grub.cfg

# Enable networking
systemctl enable NetworkManager

# Install video drivers:
pacman -S xf86-video-amdgpu xf86-video-ati xf86-video-intel xf86-video-nouveau xf86-video-vesa

# Install laptop things:
pacman -S xf86-input-synaptics acpi

#Create root password
passwd

# Create user
read Username
useradd -m $Username
usermod -a -G wheel $Username
echo "%wheel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Finish up and Reboot:
exit
umount /mnt/usb/boot /mnt/usb && sync
reboot now