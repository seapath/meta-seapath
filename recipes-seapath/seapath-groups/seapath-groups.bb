# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Seapath shared groups"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"

inherit useradd

PACKAGES =+ " \
    ${PN}-hugepages \
    ${PN}-vfio-net \
"

ALLOW_EMPTY:${PN} = "1"
ALLOW_EMPTY:${PN}-dbg = "1"
ALLOW_EMPTY:${PN}-dev = "1"
ALLOW_EMPTY:${PN}-hugepages = "1"
ALLOW_EMPTY:${PN}-vfio-net = "1"

USERADD_PACKAGES= " \
    ${PN}-hugepages \
    ${PN}-vfio-net \
"

GROUPADD_PARAM:${PN}-hugepages = "-r hugepages"

GROUPADD_PARAM:${PN}-vfio-net = "-r vfio-net"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://host/99-vfio-net.rules \
"

do_install:append() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/host/99-vfio-net.rules \
        ${D}${sysconfdir}/udev/rules.d
}

FILES:${PN}-vfio-net = " \
    ${sysconfdir}/udev/rules.d/99-vfio-net.rules \
"
