#!/bin/bash
# Copyright (C) 2020, RTE (http://www.rte-france.com)
# This program is distributed under the Apache 2 license.

usage()
{
    echo 'Flash an image on disk'
    echo 'usage: flash [-h] [-i] image -d disk'
    echo
    echo 'mandatory arguments:'
    echo '  -i,--image   image  the image wic or wic.gz image to flash'
    echo '  -d,--disk    disk   the disk to be flashed. Usualy /dev/sda'
    echo
    echo 'optional arguments:'
    echo '  -h, --help          show this help message and exit'
}


disk=
image=
options=$(getopt -o hi:d: --long image:,disk:,help -- "$@")

[ $? -eq 0 ] || {
    echo "Incorrect options provided"
    exit 1
}

eval set -- "$options"
while true; do
    case "$1" in
    -h|--help)
        usage
        exit 0
        ;;
    -i|--image)
        shift
        image="$1"
        ;;
    -d|--disk)
        shift
        disk="$1"
        ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

if [ -z "${disk}" ] ; then
    echo "Error missing argument: disk"
    usage
    exit 1
fi

if [ -z "${image}" ] ; then
    echo "Error missing argument: image"
    usage
    exit 1
fi

if [ ! -b "${disk}" ] ; then
    echo "Error $disk is not a block device"
    usage
    exit 1
fi

if [ ! -f "${image}" ] ; then
    echo "Error $image is not a file"
    usage
    exit 1
fi

bmap="${image%.*}.bmap"
if [ -f "${bmap}" ] ; then
    command="bmaptool copy \"$image\" \"${disk}\""
else
    if echo "$image" | grep -qE "\.gz$"  ; then
        command="gzip -d -c \"$image\" | dd of=\"${disk}\" bs=32M"
    else
        command="dd if=\"$image\" of=\"${disk}\" bs=32M"
    fi
fi

if eval "$command" ; then
    sync
    echo "Flash $image on $disk: success"
else
    echo "Flash $image on $disk: failed"
    exit 1
fi

# Check if GPT headers are well placed at the end of the disk
GPT_ISSUES=$(sgdisk -v $disk|grep Identified|cut -d' ' -f2)

# And fix them if not
if [ "$GPT_ISSUES" -ge 0 ]; then
    echo "Fix GPT headers"
    sgdisk -e $disk
fi

# Extend persistent partition to fit all the available space
echo "Extend data partition to remaining free space"
END=$(parted "$disk" -s unit s print free | grep 'Free Space' | tail -n1 | awk '{print $2}')
OVERLAY=$(fdisk -l ${disk} | grep '^/dev' | tail -n1 | awk -F' ' '{print $1}')
LAST_PART=$(echo "${OVERLAY}" | grep -o '[0-9]*$')
parted -s -- "${disk}" resizepart "${LAST_PART}" "${END}"

# Update file system
echo "Update file system to the new partition size"
resize2fs "${OVERLAY}"

# Check if efivarfs is mounted
if ! grep -q /sys/firmware/efi/efivars /proc/mounts ; then
    mount -t efivarfs efivarfs /sys/firmware/efi/efivars
fi


# Create boot entries
echo "EFI image."
entry_num=$(efibootmgr | awk '/SEAPATH slot 0/{ gsub("Boot", ""); gsub("*", ""); print $1 }')
if [ ! -z "$entry_num" ] ;  then
    echo "EFI entry SEAPATH slot 0 already exists. Remove it"
    command="efibootmgr -q -b $entry_num -B"
    if eval "$command" ; then
        echo "Entry SEAPATH slot 0 successfully removed"
    else
        echo "Error while removing entry SEAPATH slot 0"
        exit 1
    fi
fi

entry_num=$(efibootmgr | awk '/SEAPATH slot 1/{ gsub("Boot", ""); gsub("*", ""); print $1 }')
if [ ! -z "$entry_num" ] ;  then
    echo "EFI entry SEAPATH slot 1 already exists. Remove it"
    command="efibootmgr -q -b $entry_num -B"
    if eval "$command" ; then
        echo "Entry SEAPATH slot 1 successfully removed"
    else
        echo "Error while removing entry SEAPATH slot 1"
        exit 1
    fi
fi

command="efibootmgr -q -c -d \"$disk\" -p 2 -L \"SEAPATH slot 1\" -l /EFI/BOOT/bootx64.efi"
if eval "$command" ; then
    echo "Entry SEAPATH slot 1 successfully created"
else
    echo "Error while creating entry SEAPATH slot 1"
    exit 1
fi

command="efibootmgr -q -c -d \"$disk\" -p 1 -L \"SEAPATH slot 0\" -l /EFI/BOOT/bootx64.efi"
if eval "$command" ; then
    echo "Entry SEAPATH slot 0 successfully created"
else
    echo "Error while creating entry SEAPATH slot 0"
    exit 1
fi

# Disable slot 1
passive_boot=$(efibootmgr | awk '/SEAPATH slot 1/{ gsub("Boot", ""); gsub("*", ""); print $1 }')
if efibootmgr -q -b "${passive_boot}" -A ; then
    echo "Entry ${passive_boot} sucessfully disabled"
else
    echo "Error while disabling entry ${passive_boot}"  1>&2
    exit 1
fi

active_boot=$(efibootmgr | awk '/SEAPATH slot 0/{ gsub("Boot", ""); gsub("*", ""); print $1 }')
echo "Move SEAPATH boot at the top of the boot order"
echo "Disable all unwanted boot entry in UEFI setup or with the efibootmgr"
echo "command"
# Keep other boot entries
boot_order=$(efibootmgr | grep "BootOrder" | awk '{ print $2}')
# Remove SEAPATH entries from bootOrder
boot_order=$(echo "$boot_order" | sed "s/$active_boot//")
boot_order=$(echo "$boot_order" | sed "s/$passive_boot//")
# Remove unwanted commas
boot_order=$(echo "$boot_order" | sed "s/,,/,/")
boot_order=$(echo "$boot_order" | sed 's/,$//')
boot_order=$(echo "$boot_order" | sed 's/^,//')
# Add SEAPATH entries add the end
boot_order="$active_boot,$passive_boot,$boot_order"

# Change boot order
if efibootmgr -q -o "$boot_order" ; then
    echo "Boot order successfully changed"
else
    echo "Error while changing boot order"
    exit 1
fi
echo "Set the next reboot to be on SEAPATH slot 0"
efibootmgr --bootnext "$active_boot"
efibootmgr

echo "You can reboot. Don't forget to remove your USB key."
