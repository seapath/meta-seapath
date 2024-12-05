#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

# Mount or unmount the /boot partition
# Usage: mount-boot.sh [mount|umount]

# Get disk name and partition num for current mounted rootfs
rootfs_part=$(mount | awk '/\/ / { print $1 }')
disk_name="${rootfs_part: : -1}"
part_num="${rootfs_part:(-1)}"

# Deduce inactive bank partitions (static association)
if [[ "${part_num}" == "3" ]] ; then
    bootloader_part="${disk_name}1"
else
    bootloader_part="${disk_name}2"
fi

if [[ -z "$1" || "$1" == "mount"  ]] ; then
    mount "${bootloader_part}" /boot 2>/dev/null
elif [[ "$1" == "umount" ]] ; then
    umount /boot
fi
