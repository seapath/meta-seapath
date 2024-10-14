# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

inherit useradd

USERADD_PACKAGES = "${PN}-switch"
USERADD_PARAM:${PN}-switch = "\
    --system \
    -G hugepages,vfio-net \
    -N openvswitch \
"

GROUPADD_PARAM:${PN}-switch = "-r hugepages ; -r vfio-net ; -r openvswitch"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://openvswitch.conf \
    file://openvswitch.service \
    file://ovs-vswitchd.service \
    file://configure_vm_sockets.sh \
    file://ovsdb-server.service \
    file://set-hugepages-permissions.service \
    file://0001-utilities-ovs-lib.in-do-not-hardcode-the-log-file.patch \
    file://tmpfile-openvswitch.conf \
    file://99-vfio-net.rules \
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

    chown openvswitch:openvswitch ${D}/${sysconfdir}/openvswitch

    # Remove /var/lib/openvswitch directory and it contents. Subdirectories
    # will be created by Openv Switch at runtime with the correct permissions
    # (but not the parent directory).
    rm -rf ${D}/${localstatedir}/lib/openvswitch
    install -o openvswitch -g openvswitch \
        -d ${D}/${localstatedir}/lib/openvswitch

    # Create /run/openvswitch volatile directory each time the machine boots
    install -d ${D}/${sysconfdir}/tmpfiles.d
    install -m 0644 ${WORKDIR}/tmpfile-openvswitch.conf \
        ${D}/${sysconfdir}/tmpfiles.d/openvswitch.conf

    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/99-vfio-net.rules \
        ${D}${sysconfdir}/udev/rules.d
}

SYSTEMD_SERVICE:${PN}-switch += " \
    set-hugepages-permissions.service \
"

FILES:${PN}-switch += " \
    ${systemd_unitdir}/system/set-hugepages-permissions.service \
    ${libexecdir}/configure_vm_sockets.sh \
    ${sysconfdir}/tmpfiles.d/openvswitch.conf \
    ${localstatedir}/lib/openvswitch \
    ${sysconfdir}/udev/rules.d/99-vfio-net.rules \
"
