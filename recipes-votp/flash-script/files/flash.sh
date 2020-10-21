#!/bin/bash
# Copyright (C) 2020, RTE (http://www.rte-france.com)
# This program is distributed under the Apache 2 license.

usage()
{
    echo 'Flash an image on disk'
    echo 'usage: flash [-h] [-i] image -o disk'
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

if echo "$image" | grep -qE "\.gz$"  ; then
    command="gzip -d -c \"$image\" | dd of=\"${disk}\" bs=32M"
else
    command="dd if=\"$image\" of=\"${disk}\" bs=32M"
fi

echo "$command"
if eval "$command" ; then
    sync
    echo "Flash $image on $disk: success"
    echo "You can reboot. Don't forget to remove your USB key."
else
    echo "Flash $image on $disk: failed"
    exit 1
fi
