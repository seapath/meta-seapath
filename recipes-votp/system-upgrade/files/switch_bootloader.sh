#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0
#
# Script that switches between bootloader "SEAPATH slot 0" and "SEAPATH slot 1"
# EFI bootloader entries or disable the passive slot if the parameter disable is
# given
# Note: entries should already be created and boot order correctly

die()
{
    echo "$@" 1>&2
    exit 1
}

boot0=$(efibootmgr | \
    awk '/SEAPATH slot 0/{ gsub("Boot", ""); gsub("*", ""); print $1 }')
boot1=$(efibootmgr | \
    awk '/SEAPATH slot 1/{ gsub("Boot", ""); gsub("*", ""); print $1 }')

[ -n "${boot0}" ] || die "Could not retrieve boot0 entry in EFI boot order"
[ -n "${boot1}" ] || die "Could not retrieve boot1 entry in EFI boot order"

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

if [ "${boot0_order}" -lt "${boot1_order}" ] ; then
    active_boot="${boot0}"
    passive_boot="${boot1}"
else
    active_boot="${boot1}"
    passive_boot="${boot0}"
fi

if [ "$1" = "disable" ] ; then
    efibootmgr -q -b "${passive_boot}" -A || die "Error while disabling entry" \
        " ${passive_boot}"
else
    # Switch bootorder
    newbootorder=$(echo "${bootorder}" | \
        sed "s/${passive_boot}/${active_boot}/" | \
        sed "s/${active_boot}/${passive_boot}/")
    echo "Switch active and passive slot"
    efibootmgr -q -o "${newbootorder}" || "Error could not switch the bootorder"

    echo "Enable the passive slot"
    efibootmgr -q -b "${passive_boot}" -a || die "Error while disabling entry" \
        " ${passive_boot}"
fi
