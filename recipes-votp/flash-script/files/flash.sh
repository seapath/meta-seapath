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

echo "$command"
if eval "$command" ; then
    sync
    echo "Flash $image on $disk: success"
else
    echo "Flash $image on $disk: failed"
    exit 1
fi

# If EFI image create boot entries
if command -v efibootmgr &> /dev/null ; then
    echo "EFI image. Create boot entries"
    if ! efibootmgr | grep -q "boot0" ; then
        command="efibootmgr --create --disk \"$disk\" --part 1 --label \"boot0\" --loader /EFI/BOOT/bootx64.efi"
        if eval "$command" ; then
            echo "Entry boot0 sucessfully created"
        else
            echo "Error while creating entry boot0"
            exit 1
        fi
    fi
    if ! efibootmgr | grep -q "boot1" ; then
        command="efibootmgr --create --disk \"$disk\" --part 2 --label \"boot1\" --loader /EFI/BOOT/bootx64.efi"
        if eval "$command" ; then
            echo "Entry boot1 sucessfully created"
        else
            echo "Error while creating entry boot1"
            exit 1
        fi
    fi

    # Set top boot order priority for USB and PXE entries
    boot_order=$(efibootmgr | grep "BootOrder" | awk '{ print $2}')
    usb_entries=$(efibootmgr | awk '/USB/{ gsub("Boot",""); gsub("*", ""); print $1 }')
    pxe_entries=$(efibootmgr | awk '/PCI LAN/{ gsub("Boot",""); gsub("*", ""); print $1 }')

    # Create top priority list and remove from original boot order
    top_priority=""
    for entry in $usb_entries $pxe_entries
    do
        top_priority+=$entry","
        boot_order=${boot_order/$entry/}
    done

    # Concatenate lists and squeeze repeated commas
    boot_order=$(echo $top_priority$boot_order | tr -s ",")

    # Change boot order
    command="efibootmgr -o $boot_order"
    if eval "$command" ; then
        echo "Boot order successfully changed"
    else
        echo "Error while changing boot order"
        exit 1
    fi
fi

echo "You can reboot. Don't forget to remove your USB key."
