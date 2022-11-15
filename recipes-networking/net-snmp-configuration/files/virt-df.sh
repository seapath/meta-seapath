#!/bin/bash

# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

for devname in /dev/rbd*
do
  rbd unmap $devname 2>/dev/null
done
for guest in `virsh --connect qemu:///system list --all | awk 'NR>2 { print $2 }' | sed /^$/d`
do
  mkdir -p /tmp/virt-df
  umount /tmp/virt-df 2>/dev/null
  devname=`rbd map --read-only system_"$guest"`
  for part in $devname"p"*
  do
    mount -o ro,noload $part /tmp/virt-df 2>/dev/null
    returncode=$?
    if [ $returncode -eq 0 ]; then
  	  df -k | grep $part | awk -v guest="$guest" '{ print guest ":" $1 " total:" $2 " used:" $3 " available:" $4 " disk-usage:" $5 }'
    fi
    umount /tmp/virt-df 2>/dev/null
  done
  rbd unmap $devname
done
