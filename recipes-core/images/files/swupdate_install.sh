#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

do_preinst()
{
    bootloader_part=$(readlink -f /dev/upgradable_bootloader)
    rootfs_part=$(readlink -f /dev/upgradable_rootfs)

    echo "Pre-Install:"
    echo "  Format partitions $bootloader_part and $rootfs_part"

    if [ ! -L "/dev/upgradable_bootloader" ] ; then
        echo "Could not find symbolic link /dev/upgradable_bootloader"
        exit 1
    fi

    if [ ! -L "/dev/upgradable_rootfs" ] ; then
        echo "Could not find symbolic link /dev/upgradable_rootfs"
        exit 1
    fi

    # Make sure partitions are unmounted
    mount | grep -q $bootloader_part
    if [ $? -eq 0 ]; then
        umount -f $bootloader_part
    fi

    mount | grep -q $rootfs_part
    if [ $? -eq 0 ]; then
        umount -f $rootfs_part
    fi

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

    mkfs.vfat -n $bootloader_label $bootloader_part
    mkfs.ext4 -F $rootfs_part -L $rootfs_label
}

do_postinst()
{
    echo "Post-Install:"
    echo "  Copy /etc/fstab and switch bootloader"

    if [ ! -L "/dev/upgradable_bootloader" ] ; then
        echo "Could not find symbolic link /dev/upgradable_bootloader"
        exit 1
    fi

    if [ ! -L "/dev/upgradable_rootfs" ] ; then
        echo "Could not find symbolic link /dev/upgradable_rootfs"
        exit 1
    fi

    rootfs_part=$(readlink -f /dev/upgradable_rootfs)

    mnt_point=/tmp/mnt-$RANDOM
    mkdir -p $mnt_point
    mount $rootfs_part $mnt_point

    cp /etc/fstab $mnt_point/etc/fstab

    umount -f $mnt_point
    rmdir $mnt_point

    switch_bootloader
    if [ $? -eq 0 ] ; then
        echo "Switch bootloader successful"
    else
        echo "Switch bootloader did not succeed"
    fi

    echo "Rebooting system"
    reboot
}

case "$1" in
preinst)
    echo "call do_preinst"
    do_preinst $@
    ;;
postinst)
    echo "call do_postinst"
    do_postinst $@
    ;;
*)
    echo "default"
    exit 1
    ;;
esac
