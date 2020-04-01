# set time and date
timedatectl set-ntp true

# Make partitions.
echo "Select disk (sda or sdb):"
read disk
export $disk
sgdisk --zap-all /dev/$disk                     # Erase everything
sgdisk -n 0:0:+10MiB -t 0:ef02 /dev/$disk       # Bios Boot
sgdisk -n 0:0:+500Mib -t 0:ef00 /dev/$disk      # EFI partition
sgdisk -n 0:0:0 -t 0:8300 /dev/$disk            # Linux
sgdisk -p /dev/$disk                            # List partitions, just in case.

# Format drives.
mkfs.fat -F32 /dev/${disk}2
mkfs.ext4 /dev/${disk}3

# Mount.
mkdir -p /mnt/usb
mount /dev/${disk}3 /mnt/usb
mkdir /mnt/usb/boot
mount /dev/${disk}2 /mnt/usb/boot

# Install base system.
pacstrap /mnt/usb linux linux-firmware base base-devel nano pantheon-terminal xorg-server firefox lightdm cinnamon grub efibootmgr networkmanager code git openssh

# Use labels instead of UUIDs
genfstab -U /mnt/usb > /mnt/usb/etc/fstab

# Copy post-install to root directory
cp -rfv insideroot.sh /mnt/usb/root
chmod +x /mnt/usb/root/insideroot.sh
# enter system as root
arch-chroot /mnt/usb

# Finished running.... then unmount and reboot
umount /mnt/usb/boot /mnt/usb && sync
reboot now