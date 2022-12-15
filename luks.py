#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import getpass
import os
import json
import signal
import sys
import re
import time

volume_group = "VolGroup0"
encrypt_password = ""
cryptroot = "/dev/mapper/cryptlvm"
swap = 0

def clear():
  os.system("clear")

def signal_handler(sig, frame):
    print('')
    print('Cancelled')
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

def request_input(prompt):
  r = input(prompt)
  return r.strip()

def request_input_secured(prompt):
  p = getpass.getpass(prompt=prompt)
  return p.strip()

def get_disk_info(disk):
  lines = os.popen('lsblk ' + disk + " -J 2> /dev/null").readlines()
  js = "".join(lines)
  o = json.loads(js)
  devices = o["blockdevices"]
  if len(devices) != 1:
    return {}, False
  return devices[0], True

def list_disk():
  clear()
  disks = "".join(os.popen('lsblk -J 2> /dev/null').readlines())
  valid_disks = []
  js = json.loads(disks)
  devices = js["blockdevices"]
  print("Disks found on your system")
  print("{:<2} {:<20} {:<10}".format("No", "Device", "Size"))
  for dev in devices:
    if dev["type"] == "disk" or dev["type"] == "loop":
      valid_disks.append(dev)
      print("{:<2} {:<20} {:<10}".format(len(valid_disks), "/dev/" + dev["name"], dev["size"]))

  print("x  Don't partition, I have already mounted everything at /mnt and will install bootloader myself")
  print()
  return valid_disks

def check_disk_input(valid_disks, disk_no):
  if disk_no.lower() == "x":
    return True

  ok = True
  if not disk_no.isnumeric():
    ok = False
  else:
    disk_num = int(disk_no) - 1
    if disk_num < 0 or disk_num >= len(valid_disks):
      ok = False
  return ok

def get_install_disk():
  valid_disks = list_disk()
  if len(valid_disks) == 0:
    print("No disk found")
    sys.exit(0)

  disk = valid_disks[0]
  ok = True
  if len(valid_disks) > 0:
    disk_no = request_input("Enter option [x]: ")
    if disk_no == "":
      return "None"
    ok = check_disk_input(valid_disks, disk_no)
    while not ok:
      list_disk()
      print(disk_no, "is not a valid disk")
      disk_no = request_input("Enter option [x]: ")
      ok = check_disk_input(valid_disks, disk_no)

  if disk_no.lower() == "x":
    return "None"

  disk = valid_disks[int(disk_no) - 1]
  if "children" in disk:
    children = disk["children"]
    if len(children) > 0:
      confirm = request_input("/dev/" + disk["name"] + " contains partitions. ALL DATA WILL BE ERASED!\nAre you sure to use this disk? Type 'YES' to confirm: ")
      if confirm != "YES":
        print("Exiting")
        sys.exit(0)
  
  return "/dev/" + disk["name"]

def string_bool(b):
  if b:
    return "Yes"
  return "No"

def ask_swap():
  mem_in_kb = 0
  with open('/proc/meminfo') as file:
    for line in file:
        if 'MemTotal' in line:
            mem_in_kb = line.split()[1]
            break
  if not mem_in_kb.isnumeric():
    mem_in_kb = 0
  mem_in_gb = int(int(mem_in_kb) / 1000000)
  mem = request_input("Enter amount of swap in GiB [" + str(mem_in_gb * 2) + "]: ")
  
  if mem.strip() == "":
    return mem_in_gb * 2

  if mem.isnumeric():
    return mem
  print("Invalid swap amount")
  return ask_swap()

def print_task(task):
  print("{:<40}{:<1}".format(task, ": "), end='', flush=True)


def run_command(*args):
  cmd = " ".join(args)
  r = os.WEXITSTATUS(os.system("sh -c '" + cmd + "' >> /mnt/install_log.txt 2>&1"))
  if r != 0:
    print("\n\nError running:", cmd)
    sys.exit(0)

def ask_encryption_password():
  encrypt_password = request_input_secured("Enter encryption passphrase: ")
  if len(encrypt_password) < 8:
    print("Passphrase is too short. Please choose passphrase > 8 characters\n")
    return ask_encryption_password()
  encrypt_password_ver = request_input_secured("Re-enter encryption passphrase: ")
  if encrypt_password_ver != encrypt_password:
    print("Passphrase does not match\n")
    return ask_encryption_password()
  return encrypt_password

def format_root(partition, fs):
  if fs == "btrfs":
    run_command("/usr/bin/mkfs.btrfs", "-L", "Root", partition)
  elif fs == "xfs":
    run_command("/usr/bin/mkfs.xfs", partition)
  else:
    run_command("/usr/bin/mkfs.ext4", partition)

clear()
disk = get_install_disk()
clear()
encrypt_password = ask_encryption_password()
clear()
swap = ask_swap()

if disk != "None":
  print("Partitioning " + disk)
  print_task("Setup new partition scheme")
  run_command("/usr/bin/sgdisk", "--zap-all", disk)
  print("Done")
  print_task("Creating EPS partition")
  run_command("/usr/bin/sgdisk", "-n 0:0:+512M -t 0:ef00 -c 0:EPS", disk)
  print("Done")
  print_task("Creating LUKS partition")
  run_command("/usr/bin/sgdisk", "-n 0:0:0 -t 0:8309 -c 0:cryptlvm", disk)
  print("Done")

  run_command("/usr/bin/partprobe", disk)

  print_task("Formatting EPS partition")
  partition = os.popen('blkid ' + disk +'* | grep -oP \'/dev/[a-z0-9]*:.*PARTLABEL="EPS"\' | grep -o \'/dev/[a-z0-9]*\'').readline().strip()
  run_command("/usr/bin/mkfs.fat", "-F32", partition)
  print("Done")  

  
  cryptpartition = os.popen('blkid ' + disk +'* | grep -oP \'/dev/[a-z0-9]*:.*PARTLABEL="cryptlvm"\' | grep -o \'/dev/[a-z0-9]*\'').readline().strip()
  print_task("Encrypting LUKS partition to cryptlvm")
  run_command("echo \"" + encrypt_password + "\" |", "cryptsetup -q luksFormat", cryptpartition)
  print("Done")
  print_task("Opening LUKS partition to cryptlvm")
  run_command("echo \"" + encrypt_password + "\" |", "cryptsetup luksOpen", cryptpartition, "cryptlvm")
  print("Done")

  print_task("Creating LVM inside LUKS")
  run_command("/usr/bin/pvcreate", cryptroot)
  print("Done")
  print_task("Creating Volume Group")
  run_command("/usr/bin/vgcreate", volume_group, cryptroot)
  print("Done")

  if int(swap) > 0:
    print_task("Creating SWAP partition")
    run_command("/usr/bin/lvcreate", "-L" + str(swap) + "G -n lvSwap", volume_group)
    print("Done")
    print_task("Enabling Swap")
    partition = "/dev/mapper/" + volume_group + "-lvSwap"
    run_command("/usr/bin/mkswap", partition)
    run_command("/usr/bin/swapon", partition)
    print("Done")

  print_task("Creating root partition")
  run_command("/usr/bin/lvcreate", '-l 100%FREE -n lvRoot', volume_group)
  print("Done")
  print_task("Formatting root partition")
  partition = "/dev/mapper/" + volume_group + "-lvRoot"
  format_root(partition, filesystem)
  print("Done")
  
  partition = "/dev/mapper/" + volume_group + "-lvRoot"    
  print_task("Mounting root")
  run_command("/usr/bin/mount", partition, "/mnt")
  print("Done")
  partition = os.popen('blkid ' + disk +'* | grep -oP \'/dev/[a-z0-9]*:.*PARTLABEL="EPS"\' | grep -o \'/dev/[a-z0-9]*\'').readline().strip()
  print_task("Mounting EPS")
  run_command("/usr/bin/mkdir", "-p", "/mnt/boot/efi")
  run_command("/usr/bin/mount", partition, "/mnt/boot/efi")
  print("Done")
