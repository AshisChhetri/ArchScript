#!/bin/bash
#**************** Install Qemu KVM Virtual manager *********************************
#  _  ____     ____  __  
# | |/ /\ \   / /  \/  | 
# | ' /  \ \ / /| |\/| | 
# | . \   \ V / | |  | | 
# |_|\_\   \_/  |_|  |_| 
#                        
#  
# by Ashis Thapa Chhetri (2023) 
# ----------------------------------------------------- 

# ------------------------------------------------------
# Install Script for Libvirt
# ------------------------------------------------------
#
# Install require packages for qemu virtual machine to work ..
#

sudo pacman -S virt-manager virt-viewer qemu vde2 ebtables iptables-nft nftables dnsmasq bridge-utils ovmf swtpm


# ------------------------------------------------------
# Edit libvirtd.conf
# ------------------------------------------------------
echo "Manual steps required:"
echo "Open sudo vim /etc/libvirt/libvirtd.conf:"
echo 'Remove # at the following lines: unix_sock_group = "libvirt" and unix_sock_rw_perms = "0770"'
read -p "Press any key to open libvirtd.conf: " c
sudo vim /etc/libvirt/libvirtd.conf
sudo echo 'log_filters="3:qemu 1:libvirt"' >> /etc/libvirt/libvirtd.conf
sudo echo 'log_outputs="2:file:/var/log/libvirt/libvirtd.log"' >> /etc/libvirt/libvirtd.conf

# ------------------------------------------------------
# Add user to the group
# ------------------------------------------------------
sudo usermod -a -G kvm,libvirt $(whoami)

# ------------------------------------------------------
# Enable services
# ------------------------------------------------------
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

# ------------------------------------------------------
# Edit qemu.conf
# ------------------------------------------------------
echo "Manual steps required:"
echo "Open sudo vim /etc/libvirt/qemu.conf"
echo "Uncomment and add your user name to user and group."
echo 'user = "your username"'
echo 'group = "your username"'
read -p "Press any key to open qemu.conf: " c
sudo vim /etc/libvirt/qemu.conf

# ------------------------------------------------------
# Restart Services
# ------------------------------------------------------
sudo systemctl restart libvirtd

# ------------------------------------------------------
# Autostart Network
# ------------------------------------------------------
sudo virsh net-autostart default

echo "Please restart your system with reboot."
