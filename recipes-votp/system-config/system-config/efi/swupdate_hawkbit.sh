#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

die() {
    local msg=${*}
    echo "Fatal: ${msg}" 1>&2
    exit 1
}

HAWKBIT_DEVICE_ID="${HOSTNAME}"

[ -z "$HAWKBIT_DEVICE_ID" ] && die "please set hawkBit device id"
[ -z "$HAWKBIT_SERVER_URL" ] && die "please set hawkBbit server url"
[ -z "$HAWKBIT_SERVER_PORT" ] && die "please set hawkBit server port"
suricatta_extra_args=""

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
    if ! check-health ; then
        echo "Update tests haves failed" 1>&2
        echo "Rebooting to the last working state..."
        grub-editenv /boot/EFI/BOOT/grubenv set "bootcount=4"
        umount /boot
        reboot
        exit 1
    else
        echo "Update success"
        suricatta_extra_args="-c 2"
        rm -f /boot/EFI/BOOT/grubenv
        rm -f /var/log/update_marker
        switch_bootloader disable
    fi
fi
umount /boot
if [ -f /var/log/update_marker ] ; then
    # The update have failed
    suricatta_extra_args="-c 3"
    rm -f /var/log/update_marker
    switch_bootloader
    switch_bootloader disable
    echo "Update have failed" 1>&2
fi

swupdate -u "-u $HAWKBIT_SERVER_URL \
    -i $HAWKBIT_DEVICE_ID \
    -t default \
    $suricatta_extra_args"
