#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# This program is distributed under the Apache 2 license.
#
# Script to be called from udev partition_symlinks.rules in order to
# symlink the inactive bootloader and rootfs partitions. These symlinks
# can be later used to flash the inactive bank.
#
# This is possible since disk partitions are static:
# - Slot A: bootloader is on /dev/<disk>1 and rootfs on /dev/<disk>3
# - Slot B: bootloader is on /dev/<disk>2 and rootfs on /dev/<disk>4
#
# This script takes two positional arguments:
# - The first one indicates which type of partition to check. It must be
#   'bootloader' or 'rootfs'.
# - The second one is the partition name to verify, i. e., '/dev/sdb1'.
#
# The script echoes '1' if parameters correspond to type and name of
# inactive bank or '0' otherwise.

# Argument verification
if [[ "$#" -ne 2 ]] ; then
    echo "Script requires two arguments"
    exit 1
fi

if [[ "${1}" != "bootloader" && "${1}" != "rootfs" ]] ; then
    echo "Invalid first argument"
    exit 1
fi

# Get disk name and partition num for current mounted rootfs
rootfs_part=$(mount | awk '/\/ / { print $1 }')
disk_name="${rootfs_part: : -1}"
part_num="${rootfs_part:(-1)}"

# Deduce inactive bank partitions (static association)
if [[ "${part_num}" == "3" ]] ; then
    inactive_bootloader_p="${disk_name}2"
    inactive_rootfs_p="${disk_name}4"
else
    inactive_bootloader_p="${disk_name}1"
    inactive_rootfs_p="${disk_name}3"
fi

# Verify if parameters correspond to type and name of current inactive partition
if [[ "${1}" == "bootloader" && "${2}" == "${inactive_bootloader_p}" || "${1}" == "rootfs" && "${2}" == "${inactive_rootfs_p}" ]] ; then
    echo 1
else
    echo 0
fi
