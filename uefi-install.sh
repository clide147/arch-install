# set time and date
timedatectl set-ntp true
# Make partitions.
lsblk
echo "Select disk (sda or sdb):"
read disk
sgdisk --zap-all /dev/$disk                     # Erase everything
sgdisk -n 0:0:+500Mib -t 0:ef00 /dev/$disk      # EFI partition
sgdisk -n 0:0:0 -t 0:8300 /dev/$disk            # Linux
sgdisk -p /dev/$disk                            # List partitions, just in case.

# Format drives.
mkfs.fat -F32 /dev/${disk}1
mkfs.ext4 -F /dev/${disk}2

# Mount.
mkdir -p /mnt
mount /dev/${disk}2 /mnt
mkdir /mnt/boot
mount /dev/${disk}1 /mnt/boot

# Install base system.
pacstrap /mnt linux linux-firmware base base-devel nano sudo --noconfirm --needed

# Use labels instead of UUIDs
genfstab -U /mnt > /mnt/etc/fstab

# Copy post-install to root directory
cp -rfv uefi-insideroot.sh /mnt/root
chmod +x /mnt/root/uefi-insideroot.sh
# enter system as root
arch-chroot /mnt ~/./uefi-insideroot.sh

# Finished running.... then unmount and reboot
umount /mnt/boot /mnt && sync
reboot now