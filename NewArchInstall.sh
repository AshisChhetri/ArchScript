#!/bin/bash
clear
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "by Ashis Thapa Chhetri (2023)"
echo "-----------------------------------------------------"
echo ""
echo "Important: Please make sure that you have followed the "
echo "manual steps in the README to partition the harddisc!"
echo "Warning: Run this script at your own risk."
echo ""


sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/" /etc/pacman.conf

# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
lsblk
read -p "Enter the name of the EFI partition (eg. sda1): " efipartition
read -p "Enter the name of the ROOT partition (eg. sda2): " rootpartition
read -p "Do you have seperate Home partition ? (y/n) :" sephome

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
timedatectl set-ntp true


# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
# Formating boot partition
mkfs.fat -F 32 /dev/$efipartition;
#  Formating root partition
mkfs.ext4 /dev/$rootpartition;

# ------------------------------------------------------
# Mount partition
# ------------------------------------------------------
# mount root partition on /mnt
mount /dev/$rootpartition /mnt

# make dir for boot/efi and home folder
mkdir -p /mnt/boot

# mount boot partition on /mnt/boot/efi path
mount /dev/$efipartition /mnt/boot

# mount home partition
if [[ $sephome = y ]] ; then
    mkdir -p /mnt/home
    read -p "Enter the name of home partition :" homepartition
    read -p "Do you want to format home partition ? (y/n)" homeformat
    if [[ $homeformat = y ]] ; then
        mkfs.ext4 /dev/$homepartition
    fi
    mount /dev/$homepartition /mnt/home
fi

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
pacstrap -K /mnt base linux linux-firmware vim networkmanager grub efibootmgr os-prober intel-ucode wget devel

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab


# ------------------------------------------------------
# Install configuration scripts
# ------------------------------------------------------
mkdir /mnt/archinstall
cp 2-configuration.sh /mnt/archinstall/
cp 3-AshisPackages.sh /mnt/archinstall/


# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
arch-chroot /mnt ./archinstall/2-configuration.sh

