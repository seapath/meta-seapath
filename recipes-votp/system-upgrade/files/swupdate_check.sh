#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

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

mount "${bootloader_part}" /boot 2>/dev/null
# The system has been updated
if [ -f /boot/EFI/BOOT/grubenv ] ; then
    if ! /usr/share/update/check-health.sh ; then
        echo "Update tests haves failed" 1>&2
        echo "Rebooting to the last working state..."
        grub-editenv /boot/EFI/BOOT/grubenv set "bootcount=4"
        umount /boot
        reboot
        exit 1
    else
        echo "Update success"
        rm -f /boot/EFI/BOOT/grubenv
        rm -f /var/log/update_marker
        /usr/share/update/switch_bootloader.sh disable
        touch /var/log/update_success
    fi
fi
umount /boot
if [ -f /var/log/update_marker ] ; then
    # The update have failed
    rm -f /var/log/update_marker
    /usr/share/update/switch_bootloader.sh
    /usr/share/update/switch_bootloader.sh disable
    echo "Update have failed" 1>&2
    touch /var/log/update_fail
fi
