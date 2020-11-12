uuidline=blkid | grep "/dev/sda2"
echo $uuidline

PART_ID=$(blkid -o value -s UUID /dev/sda2)
echo $PART_ID

read -p "Pause"

bootctl install
cat <<EOF > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root="LABEL=ROOT" rw
EOF

cat /boot/loader/entries/arch.conf

read -p "pause"
# echo "--------------------------------------"
# echo "--          Network Setup           --"
# echo "--------------------------------------"
# pacman -S networkmanager dhclient --noconfirm --needed
# systemctl enable --now NetworkManager

# echo "--------------------------------------"
# echo "--      Set Password for Root       --"
# echo "--------------------------------------"
# echo "Enter password for root user: "
# passwd root

# exit

# ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
# hwclock --systohc
# echo en_US.UTF-8 UTF-8 > /etc/locale.gen
# locale-gen
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# echo "What hostname do you want?"
# read hostname
# echo $hostname > /etc/hostname
# echo "127.0.0.1     localhost" > /etc/hosts
# echo "::1     localhost" >> /etc/hosts
# echo "127.0.1.1     $hostname.localdomain   $hostname" >> /etc/hosts
# echo "--------------------------------------------------------"
# #setup Ramdisk:
# sed 's/HOOKS/#HOOKS/g' /etc/mkinitcpio.conf
# echo "HOOKS=(base udev block filesystems keyboard fsck)" > /etc/mkinitcpio.conf
# mkinitcpio -p linux
# echo "--------------------------------------------------------"

# # Setup network interface names to wlan0 and eth0 as default
# ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules

# # Limit Journaling:
# echo "Storage=volatile" >> /etc/systemd/journald.conf
# echo "SystemMaxUse=16M" >> /etc/systemd/journald.conf
# sed 's/relatime/noatime/g' /etc/fstab
# echo "--------------------------------------------------------"

# # This might help things:
# rm -f /var/lib/pacman/db.lck

# echo -e "\nInstalling Base System\n"

# PKGS=(

#     # --- XORG Display Rendering
#         'xorg'                  # Base Package
#         'xorg-drivers'          # Display Drivers 
#         'xterm'                 # Terminal for TTY
#         'xorg-server'           # XOrg server
#         'xorg-apps'             # XOrg apps group
#         'xorg-xinit'            # XOrg init
#         'xorg-xinput'           # Xorg xinput
#         'mesa'                  # Open source version of OpenGL

#     # --- Setup Desktop
#         'awesome'               # Awesome Desktop
#         'xfce4-power-manager'   # Power Manager 
#         'rofi'                  # Menu System
#         'picom'                 # Translucent Windows
#         'xclip'                 # System Clipboard
#         'gnome-polkit'          # Elevate Applications
#         'lxappearance'          # Set System Themes

#     # --- Login Display Manager
#         'lightdm'                   # Base Login Manager
#         'lightdm-webkit2-greeter'   # Framework for Awesome Login Themes

#     # --- Networking Setup
#         'wpa_supplicant'            # Key negotiation for WPA wireless networks
#         'dialog'                    # Enables shell scripts to trigger dialog boxex
#         'openvpn'                   # Open VPN support
#         'networkmanager-openvpn'    # Open VPN plugin for NM
#         'network-manager-applet'    # System tray icon/utility for network connectivity
#         'libsecret'                 # Library for storing passwords
    
#     # --- Audio
#         'alsa-utils'        # Advanced Linux Sound Architecture (ALSA) Components https://alsa.opensrc.org/
#         'alsa-plugins'      # ALSA plugins
#         'pulseaudio'        # Pulse Audio sound components
#         'pulseaudio-alsa'   # ALSA configuration for pulse audio
#         'pavucontrol'       # Pulse Audio volume control
#         'pnmixer'           # System tray volume control

#     # --- Bluetooth
#         'bluez'                 # Daemons for the bluetooth protocol stack
#         'bluez-utils'           # Bluetooth development and debugging utilities
#         'bluez-firmware'        # Firmwares for Broadcom BCM203x and STLC2300 Bluetooth chips
#         'blueberry'             # Bluetooth configuration tool
#         'pulseaudio-bluetooth'  # Bluetooth support for PulseAudio
    
#     # --- Printers
#         'cups'                  # Open source printer drivers
#         'cups-pdf'              # PDF support for cups
#         'ghostscript'           # PostScript interpreter
#         'gsfonts'               # Adobe Postscript replacement fonts
#         'hplip'                 # HP Drivers
#         'system-config-printer' # Printer setup  utility
# )

# for PKG in "${PKGS[@]}"; do
#     echo "INSTALLING: ${PKG}"
#     sudo pacman -S "$PKG" --noconfirm --needed
# done

# echo -e "\nDone!\n"