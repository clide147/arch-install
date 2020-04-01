echo "Select disk (sda or sdb):"
read disk
echo $disk

sgdisk --zap-all /dev/$disk
sgdisk -n 0:0:+10MiB -t 0:ef02 /dev/$disk
sgdisk -n 0:0:+500Mib -t 0:ef00 /dev/$disk
sgdisk -n 0:0:0 -t 0:8300 /dev/$disk
sgdisk -p /dev/$disk