# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

do_configure[depends] += "virtual/kernel:do_shared_workdir"
do_compile[depends] += "make-mod-scripts:do_configure"

SYSTEMD_AUTO_ENABLE_${PN}-switch = "disable"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://openvswitch.service-require-loaded-iommu.patch \
    file://ovs-vswitchd.service-add-sandboxing-options.patch \
    file://ovs-vswitchd.service-create-vm-sockets-directory.patch \
    file://ovsdb-server.service-add-sandboxing-options.patch \
    file://systemd-move-conf-db-out-of-etc.patch \
    file://fix-prandom-max.patch \
"
