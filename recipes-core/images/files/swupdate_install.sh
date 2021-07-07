#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

die()
{
    echo "$@" 1>&2
    exit 1
}

do_preinst()
{
    echo "Pre-Install:"

    if [ ! -L "/dev/upgradable_bootloader" ] ; then
        die "Could not find symbolic link /dev/upgradable_bootloader"
    fi

    if [ ! -L "/dev/upgradable_rootfs" ] ; then
        die "Could not find symbolic link /dev/upgradable_rootfs" 1>&2
    fi
    bootloader_part=$(readlink -f /dev/upgradable_bootloader)
    rootfs_part=$(readlink -f /dev/upgradable_rootfs)

    # Make sure partitions are unmounted
    umount -f "$bootloader_part"
    umount -f "$rootfs_part"

    # Labels can be deduced from static partitioning
    # - Slot A: /dev/<disk>1 (bootloader) + /dev/<disk>3 (rootfs)
    # - Slot B: /dev/<disk>2 (bootloader) + /dev/<disk>4 (rootfs)

    part_num="${rootfs_part:(-1)}"

    if [[ "${part_num}" == "3" ]] ; then
        bootloader_label="efi0"
        rootfs_label="rootfs0"
    else
        bootloader_label="efi1"
        rootfs_label="rootfs1"
    fi

    if ! mkfs.vfat -n "$bootloader_label" "$bootloader_part" ; then
        die "Error when formating the boot partition"
    fi
    if ! mkfs.ext4 -F "$rootfs_part" -L "$rootfs_label" ; then
        die "Error when formating the root partition"
    fi
}

do_postinst()
{
    echo "Post-Install:"

    # Update grubenv
    if ! mount -t vfat /dev/upgradable_bootloader /boot ; then
        die "Could not mount /dev/upgradable_bootloader"
    fi


    if ! grub-editenv /boot/EFI/BOOT/grubenv create ; then
        die "Could not create grubenv"
    fi
    if ! grub-editenv /boot/EFI/BOOT/grubenv set bootcount=0 ; then
        die "Could not set bootcount in grubenv"
    fi

    if ! umount -f /boot  ; then
        die "Could not unmount /boot"
    fi

    touch /mnt/persistent/update_marker

    switch_bootloader || echo "Switch bootloader did not succeed" 1>&2

    echo "Rebooting system"
    reboot
}

case "$1" in
preinst)
    echo "call do_preinst"
    do_preinst
    ;;
postinst)
    echo "call do_postinst"
    do_postinst
    ;;
*)
    die "Incorrect command"
    ;;
esac
