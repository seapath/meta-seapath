# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

do_configure[depends] += "virtual/kernel:do_shared_workdir"
do_compile[depends] += "make-mod-scripts:do_configure"

inherit useradd

USERADD_PACKAGES= "${PN}"
USERADD_PARAM_${PN} = " \
    --system \
    -U openvswitch \
"

SYSTEMD_AUTO_ENABLE_${PN}-switch = "disable"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://openvswitch.conf \
    file://openvswitch.service \
    file://ovs-vswitchd.service \
    file://ovsdb-server.service \
    file://fix-prandom-max.patch \
"

do_install_append()  {
    install -d ${D}/${sysconfdir}/sysconfig/
    install -m 0644 ${WORKDIR}/openvswitch.conf \
        ${D}${sysconfdir}/sysconfig/openvswitch

    install -d ${D}/${systemd_unitdir}/system/
    install -m 644 ${WORKDIR}/openvswitch.service \
        ${D}/${systemd_unitdir}/system/openvswitch.service
    install -m 644 ${WORKDIR}/ovs-vswitchd.service \
        ${D}/${systemd_unitdir}/system/ovs-vswitchd.service
    install -m 644 ${WORKDIR}/ovsdb-server.service \
        ${D}/${systemd_unitdir}/system/ovsdb-server.service
}
