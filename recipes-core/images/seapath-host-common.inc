# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A production image for Seapath"
require seapath-common.inc

# Virtualization
IMAGE_INSTALL_append = " \
    libvirt \
    libvirt-libvirtd \
    libvirt-virsh \
    libvirt-python \
    openvswitch \
    qemu \
"
# HA
IMAGE_INSTALL_append = " \
    pacemaker \
    cluster-glue \
    cluster-glue-plugin-stonith2 \
    cluster-glue-plugin-stonith2-ribcl \
    cluster-glue-plugin-stonith-external \
    cluster-glue-plugin-interfacemgr \
    cluster-glue-plugin-test \
    cluster-glue-plugin-raexec \
    crmsh \
    drbd-utils \
    ceph \
    resource-agents \
    dlm \
    xfsprogs \
"
