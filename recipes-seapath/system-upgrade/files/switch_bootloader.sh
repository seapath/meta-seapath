#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Script that switches between bootloader "SEAPATH slot 0" and "SEAPATH slot 1"
# EFI bootloader entries or disable the passive slot if the parameter disable is
# given
# Note: entries should already be created and boot order correctly

set -e

die()
{
    echo "$@" 1>&2
    exit 1
}

# Check if efivarfs is mounted
if ! grep -q /sys/firmware/efi/efivars /proc/mounts ; then
    mount -t efivarfs efivarfs /sys/firmware/efi/efivars
fi

boot0=$(efibootmgr | \
    awk '/SEAPATH slot 0/{ gsub("Boot", ""); gsub("*", ""); print $1 }')
boot1=$(efibootmgr | \
    awk '/SEAPATH slot 1/{ gsub("Boot", ""); gsub("*", ""); print $1 }')

if [ ! -n "${boot0}" ] ; then
    die "Could not retrieve boot0 entry in EFI boot order"
fi
if [ -z "${boot1}" ] ;then
    echo "Recreate SEAPATH slot 1 entry"
    upgradable_bootloader=$(readlink -f /dev/upgradable_bootloader)
    if [ -z "${upgradable_bootloader}" ] ; then
        die "Could not find upgradable bootloader"
    fi
    disk="/dev/$(lsblk -no pkname ${upgradable_bootloader})"
    if ! efibootmgr \
        -q -c -d "$disk" \
        -p 2 \
        -L "SEAPATH slot 1" \
        -l /EFI/BOOT/bootx64.efi
    then
        die "Error while creating SEAPATH slot 1 entry"
    fi
    exit 0
fi

bootorder=$(efibootmgr |grep "BootOrder:")
bootorder="${bootorder:11}"

boot0_order=$(echo "${bootorder}" | \
    tr ',' '\n' | \
    grep -n "${boot0}" | \
    cut -d ':' -f 1)

boot1_order=$(echo "${bootorder}" | \
    tr ',' '\n' | \
    grep -n "${boot1}" | \
    cut -d ':' -f 1)

if [ "${boot0_order}" = "" ]; then
  bootorder=$(echo "${bootorder}" | sed "s/${boot1}/${boot1},${boot0}/")
  boot0_order=$(echo "${bootorder}" | \
    tr ',' '\n' | \
    grep -n "${boot0}" | \
    cut -d ':' -f 1)
fi

if [ "${boot1_order}" = "" ]; then
  bootorder=$(echo "${bootorder}" | sed "s/${boot0}/${boot0},${boot1}/")
  boot1_order=$(echo "${bootorder}" | \
    tr ',' '\n' | \
    grep -n "${boot1}" | \
    cut -d ':' -f 1)
fi

if [ "${boot0_order}" -lt "${boot1_order}" ] ; then
    active_boot="${boot0}"
    passive_boot="${boot1}"
else
    active_boot="${boot1}"
    passive_boot="${boot0}"
fi

if [ "$1" = "disable" ] ; then
    if ! efibootmgr -q -b "${passive_boot}" -A ; then
        die "Error while disabling entry ${passive_boot}"
    fi
else
    # Switch bootorder
    newbootorder=$(echo "${bootorder}" | \
        sed "s/${passive_boot}/${active_boot}/" | \
        sed "s/${active_boot}/${passive_boot}/")
    echo "Switch active and passive slot"
    if ! efibootmgr -q -o "${newbootorder}" ; then
        die "Error could not switch the bootorder"
    fi

    echo "Enable the passive slot"
    if ! efibootmgr -q -b "${passive_boot}" -a ; then
        die "Error while disabling entry ${passive_boot}"
    fi
fi
