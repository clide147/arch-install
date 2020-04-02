# set time and date
timedatectl set-ntp true
# Make partitions.
lsblk
echo "Select disk (sda or sdb):"
read disk
sgdisk --zap-all /dev/$disk                     # Erase everything
sgdisk -n 0:0:+10MiB -t 0:ef02 /dev/$disk       # Bios Boot
sgdisk -n 0:0:+500Mib -t 0:ef00 /dev/$disk      # EFI partition
sgdisk -n 0:0:0 -t 0:8300 /dev/$disk            # Linux
sgdisk -p /dev/$disk                            # List partitions, just in case.

# Format drives.
mkfs.fat -F32 /dev/${disk}2
mkfs.ext4 -F /dev/${disk}3

# Mount.
mkdir -p /mnt/usb
mount /dev/${disk}3 /mnt/usb
mkdir /mnt/usb/boot
mount /dev/${disk}2 /mnt/usb/boot

# Update package database
pacman -Sy --noconfirm reflector
reflector --verbose --country 'United States' -l 15 --sort rate --save /etc/pacman.d/mirrorlist

# Install base system.
pacstrap /mnt/usb linux linux-firmware base base-devel nano 

# Use labels instead of UUIDs
genfstab -U /mnt/usb > /mnt/usb/etc/fstab

# Copy post-install to root directory
cp -rfv insideroot.sh /mnt/usb/root
chmod +x /mnt/usb/root/insideroot.sh
# enter system as root
arch-chroot /mnt/usb ~/./insideroot.sh

# Finished running.... then unmount and reboot
umount /mnt/usb/boot /mnt/usb && sync
reboot now