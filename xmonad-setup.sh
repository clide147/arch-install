

timedatectl set-ntp true

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
mkdir /mnt/boot/efi
mount /dev/${disk}1 /mnt/boot/efi
pacstrap /mnt base base-devel linux linux-firmware nano
genfstab -U /mnt >> /mnt/etc/fstab

cp -rfv xmonad-inside.sh /mnt/root
chmod +x /mnt/root/xmonad-inside.sh
# enter system as root
arch-chroot /mnt ~/./xmonad-inside.sh

arch-chroot /mnt

umount -R /mnt
reboot