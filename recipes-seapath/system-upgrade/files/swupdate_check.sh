#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

/usr/share/update/mount_boot.sh mount

# The system has been updated
if [ -f /boot/EFI/BOOT/grubenv ] ; then
    if ! /usr/share/update/check-health.sh ; then
        echo "Update tests haves failed" 1>&2
        echo "Rebooting to the last working state..."
        grub-editenv /boot/EFI/BOOT/grubenv set "bootcount=4"
        /usr/share/update/mount_boot.sh umount
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

/usr/share/update/mount_boot.sh umount
if [ -f /var/log/update_marker ] ; then
    # The update have failed
    rm -f /var/log/update_marker
    /usr/share/update/switch_bootloader.sh
    /usr/share/update/switch_bootloader.sh disable
    echo "Update have failed" 1>&2
    touch /var/log/update_fail
fi
