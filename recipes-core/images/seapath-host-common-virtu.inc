# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

# Virtualization
IMAGE_INSTALL_append = " \
    dpdk-tools \
    libvirt \
    libvirt-libvirtd \
    libvirt-virsh \
    libvirt-python \
    openvswitch \
    qemu \
"
