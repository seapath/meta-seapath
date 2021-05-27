# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Votp shared groups"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"

inherit useradd

PACKAGES =+ " \
    ${PN}-hugepages \
    ${PN}-vfio-net \
"

USERADD_PACKAGES= " \
    ${PN}-hugepages \
    ${PN}-vfio-net \
"

GROUPADD_PARAM_${PN}-hugepages = "-r hugepages"
ALLOW_EMPTY_${PN}-hugepages = "1"

GROUPADD_PARAM_${PN}-vfio-net = "-r vfio-net"
ALLOW_EMPTY_${PN}-vfio-net = "1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://host/99-vfio-net.rules \
"

do_install_append() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/host/99-vfio-net.rules \
        ${D}${sysconfdir}/udev/rules.d
}

FILES_${PN}-vfio-net = " \
    ${sysconfdir}/udev/rules.d/99-vfio-net.rules \
"
