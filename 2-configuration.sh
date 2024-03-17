#!/bin/bash

#   ____             __ _                       _   _             
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                         |___/                                   
# by Ashis Chhetri (2023)
# ------------------------------------------------------

clear
keyboardlayout="us"
zoneinfo="Asia/Katmandu"
read -p "Enter Hoatname eg:arch :" hostname
read -p "Enter User Name : " username

pacman -S --noconfirm sed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/" /etc/pacman.conf

# ------------------------------------------------------
# Set System Time
# ------------------------------------------------------
ln -sf /usr/share/zoneinfo/$zoneinfo /etc/localtime
hwclock --systohc

# ------------------------------------------------------
# Update reflector
# ------------------------------------------------------
echo "Start reflector..."
reflector -c "India," -p https -a 3 --sort rate --save /etc/pacman.d/mirrorlist

# ------------------------------------------------------
# Synchronize mirrors
# ------------------------------------------------------
pacman -Syy

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
pacman --noconfirm -S network-manager-applet firefox sudo base-devel


# Uncomment the locale needed
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

#Generate it
locale-gen

# ------------------------------------------------------
# Set Keyboard and language
# ------------------------------------------------------

# Create locale.conf and set the language
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
# Set keyboard layout
echo "KEYMAP=us" >> /etc/vconsole.conf

# ------------------------------------------------------
# Set hostname and localhost
# ------------------------------------------------------
echo $hostname >> /etc/hostname
echo -e "127.0.0.1	localhost\n::1		localhost\n127.0.1.1	archx64.localdomain	archx64" >> /etc/hosts


# ------------------------------------------------------
# Set Root Password
# ------------------------------------------------------
# echo "Set root password"
# passwd 

# ------------------------------------------------------
# Add User
# ------------------------------------------------------
echo "Add user $username"
useradd -m -G wheel $username
passwd $username
# ------------------------------------------------------
# Enable Services
# ------------------------------------------------------
# Enable networkmanager service
systemctl enable NetworkManager.service

# Recreate initramfs 
mkinitcpio -P

#--------------------------------------------------------
# GRUB Install
#-------------------------------------------------------
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg

#---------------------------------------------------------
#  Install YAY helper
#---------------------------------------------------------
cd /opt

# Clone yay-bin from the AUR repository
git clone https://aur.archlinux.org/yay-bin.git

# Navigate into the yay-bin directory
cd yay-bin

# Build and install yay-bin using makepkg
makepkg -si


# ------------------------------------------------------
# Add user to wheel
# ------------------------------------------------------
clear
echo "Uncomment %wheel group in sudoers (around line 85):"
echo "Before: #%wheel ALL=(ALL:ALL) ALL"
echo "After:  %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Open sudoers now?" c
EDITOR=vim sudo -E visudo



clear
echo "     _                   "
echo "  __| | ___  _ __   ___  "
echo " / _' |/ _ \| '_ \ / _ \ "
echo "| (_| | (_) | | | |  __/ "
echo " \__,_|\___/|_| |_|\___| "
echo "                         "
echo ""
echo " Installation complete please reboot your system. "

