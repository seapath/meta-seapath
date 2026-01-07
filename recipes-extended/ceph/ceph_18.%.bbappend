# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/ceph-18:"

SRC_URI:append = " \
    file://0001-systemd-ceph-volume-do-not-block-indefinitely-on-cep.patch \
"

include ceph.inc

# ceph-volume requires python3-packaging
RDEPENDS:${PN} += "python3-packaging"

PACKAGE_BEFORE_PN:append = " ${PN}-cephadm"

do_install:append() {
    # Fix python3 shebangs in ceph-node-proxy
    sed -i '1 s|^#!.*|#!/usr/bin/env python3|' ${D}${sbindir}/ceph-node-proxy
}

FILES:${PN} += " ${systemd_unitdir}/system/ceph-exporter.service"
FILES:${PN}-cephadm += " ${sbindir}/cephadm "
SYSTEMD_SERVICE:${PN} += "ceph-exporter.service"
