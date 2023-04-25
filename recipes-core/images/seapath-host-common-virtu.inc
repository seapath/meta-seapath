# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

# Virtualization
IMAGE_INSTALL:append = " \
    dpdk-tools \
    libvirt \
    libvirt-libvirtd \
    libvirt-virsh \
    libvirt-python \
    net-snmp-configuration-virtualization \
    openvswitch \
    qemu \
"
