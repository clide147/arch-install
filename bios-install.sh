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
mkdir -p /mnt
mount /dev/${disk}3 /mnt
mkdir /mnt/boot
mount /dev/${disk}2 /mnt/boot


# Install base system.
pacstrap /mnt linux linux-firmware base base-devel nano 

# Use labels instead of UUIDs
genfstab -U /mnt > /mnt/etc/fstab

# Copy post-install to root directory
cp -rfv bios-insideroot.sh /mnt/root
chmod +x /mnt/root/insideroot.sh
# enter system as root
arch-chroot /mnt ~/./insideroot.sh

# Finished running.... then unmount and reboot
umount /mnt/boot /mnt && sync
reboot now