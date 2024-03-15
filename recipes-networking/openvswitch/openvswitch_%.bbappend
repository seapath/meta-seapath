# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0


DEPENDS += " seapath-groups"
RDEPENDS:${PN} += " \
    seapath-groups-hugepages \
    seapath-groups-vfio-net \
"

inherit useradd
inherit create-dirs

USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = " \
    --system \
    -G hugepages,vfio-net \
    -U openvswitch \
"

SERVICE_DIRS_LIST = " openvswitch"
SERVICE_DIRS_PREFIX = "{log,lib,run}"
SERVICE_DIRS_OWNER = "openvswitch:openvswitch"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://openvswitch.conf \
    file://openvswitch.service \
    file://ovs-vswitchd.service \
    file://configure_vm_sockets.sh \
    file://ovsdb-server.service \
    file://set-hugepages-permissions.service \
"

do_install:append()  {
    install -d ${D}/${sysconfdir}/sysconfig/
    install -m 0644 ${WORKDIR}/openvswitch.conf \
        ${D}${sysconfdir}/sysconfig/openvswitch

    install -d ${D}/${systemd_unitdir}/system/
    install -m 644 ${WORKDIR}/openvswitch.service \
        ${D}/${systemd_unitdir}/system/openvswitch.service
    install -m 644 ${WORKDIR}/ovs-vswitchd.service \
        ${D}/${systemd_unitdir}/system/ovs-vswitchd.service
    install -d ${D}/${libexecdir}
    install -m 755 ${WORKDIR}/configure_vm_sockets.sh \
        ${D}/${libexecdir}/configure_vm_sockets.sh
    install -m 644 ${WORKDIR}/ovsdb-server.service \
        ${D}/${systemd_unitdir}/system/ovsdb-server.service
    install -m 644 ${WORKDIR}/set-hugepages-permissions.service \
        ${D}/${systemd_unitdir}/system/set-hugepages-permissions.service
}

SYSTEMD_SERVICE:${PN} += " \
    set-hugepages-permissions.service \
"

FILES:${PN} += " \
    ${systemd_unitdir}/system/set-hugepages-permissions.service \
    ${libexecdir}/configure_vm_sockets.sh \
"
