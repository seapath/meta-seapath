# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

inherit create-dirs

SERVICE_DIRS_LIST = "libvirt"
SERVICE_DIRS_PREFIX = "{cache,lib,log,run}"
SERVICE_DIRS_OWNER = "root:root"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://libvirtd \
    file://libvirtd.conf \
    file://libvirtd.service \
    file://qemu.conf \
"

do_install:append() {
    install -d ${D}/${sysconfdir}/sysconfig/
    install -m 0644 ${WORKDIR}/libvirtd \
        ${D}${sysconfdir}/sysconfig/libvirtd

    install -d ${D}/${sysconfdir}/libvirt/
    install -m 0644 ${WORKDIR}/libvirtd.conf \
        ${D}${sysconfdir}/libvirt/libvirtd.conf
    install -m 0644 ${WORKDIR}/qemu.conf \
        ${D}${sysconfdir}/libvirt/qemu.conf

    install -d ${D}/${systemd_unitdir}/system/
    install -m 644 ${WORKDIR}/libvirtd.service \
        ${D}/${systemd_unitdir}/system/libvirtd.service

    rm -f ${D}${sysconfdir}/libvirt/qemu/networks/autostart/default.xml
    rm -f ${D}${sysconfdir}/libvirt/qemu/networks/default.xml
}

FILES:${PN} += " \
    ${sysconfdir}/sysconfig/libvirtd \
    ${sysconfdir}/libvirt/libvirtd.conf \
    ${sysconfdir}/libvirt/qemu.conf \
    ${systemd_unitdir}/system/libvirtd.service \
"
