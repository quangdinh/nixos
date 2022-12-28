#!/usr/bin/env bash

partBoot=p1
partCrypt=p2

disk=$1

# Remove partitions
sgdisk --zap-all $disk

# Create EPS
sgdisk -n 0:0:+512M -t 0:ef00 -c 0:EPS $disk
mkfs.fat -F32 $disk$partBoot

# Create LUKS
sgdisk -n -n 0:0:0 -t 0:8309 -c 0:cryptlvm $disk 

# Setup luks
cryptsetup luksFormat $disk$partCrypt
cryptsetup luksOpen $disk$partCrypt cryptlvm

# Setup volumes
pvcreate /dev/mapper/cryptlvm
vgcreate VolGroup0 /dev/mapper/cryptlvm

# Create swap
lvcreate -L 32G -n lvSwap VolGroup0
mkswap /dev/mapper/VolGroup0-lvSwap
swapon /dev/mapper/VolGroup0-lvSwap

# Create root
lvcreate -l 100%FREE -n lvRoot VolGroup0
mkfs.ext4 /dev/mapper/VolGroup0-lvRoot

mount /dev/mapper/VolGroup0-lvRoot /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi

nixos-generate-config --root /mnt
