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

echo "--------------------------------------"
echo "--      Set Password for Root       --"
echo "--------------------------------------"
echo "Enter password for root user: "
passwd root

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have " $nc" cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for "$nc" cores."
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf

echo "-------------------------------------------------"
echo "       Setup Language to US and set locale       "
echo "-------------------------------------------------"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone America/Chicago
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_COLLATE="" LC_TIME="en_US.UTF-8"

# Set keymaps
localectl --no-ask-password set-keymap us

# Hostname
read -p "What is the Hostname?" hostname
hostnamectl --no-ask-password set-hostname $hostname

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
read -p "Add user:" username
useradd -m $username 
passwd $username
echo "${username}  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${username}
exit

