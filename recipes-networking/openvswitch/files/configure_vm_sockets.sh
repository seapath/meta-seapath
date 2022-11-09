#!/bin/sh

# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

# This script create the vm-sockets dir only if qemu group is present
# Thus, vm-sockets will only exist on hypervisors

getent group qemu > /dev/null
if [ $? -eq 0 ];
then
  mkdir -p /run/openvswitch/vm-sockets
  chown -R qemu /run/openvswitch/vm-sockets
  chmod g+ws /run/openvswitch/vm-sockets
fi
