#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# This program is distributed under the Apache 2 license.
#
# Script that switches between bootloader boot0 and boot1 EFI entries
# by enabling / disabling them accordingly.
# Note: entries should already be created and boot order correctly
# set. Symlink '/dev/upgradable_bootloader' also has to be created.

if [ ! -L "/dev/upgradable_bootloader" ] ; then
    echo "Could not find symbolic link /dev/upgradable_bootloader"
    exit 1
fi

# Get boot0 and boot1 entry num
entry_boot0=$(efibootmgr |  awk '/boot0/{ gsub("Boot",""); gsub("*", ""); print $1 }')
entry_boot1=$(efibootmgr |  awk '/boot1/{ gsub("Boot",""); gsub("*", ""); print $1 }')

# Check which bootloader is inactive
# - Slot A: bootloader is on /dev/<disk>1
# - Slot B: bootloader is on /dev/<disk>2
upgradable_bootloader=$(readlink -f "/dev/upgradable_bootloader")
part_num="${upgradable_bootloader:(-1)}"

if [[ "${part_num}" == "1" ]] ; then
    entry_to_enable=${entry_boot0}
    entry_to_disable=${entry_boot1}
else
    entry_to_enable=${entry_boot1}
    entry_to_disable=${entry_boot0}
fi

# Enable entry
command="efibootmgr -b ${entry_to_enable} -a"
if eval "$command" ; then
    echo "Entry ${entry_to_enable} sucessfully enabled"
else
    echo "Error while enabling entry ${entry_to_enable}"
    exit 1
fi

# Disable entry
command="efibootmgr -b ${entry_to_disable} -A"
if eval "$command" ; then
    echo "Entry ${entry_to_disable} sucessfully disabled"
else
    echo "Error while disabling entry ${entry_to_disable}"
    exit 1
fi

# Reboot on the enabled entry
reboot
