# Copyright (C) 2025-2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "cockpit cluster dashboard"
DESCRIPTION = "Cockpit plugin to manage virtual machines in a cluster environment."
HOMEPAGE = "https://github.com/seapath/cockpit-cluster-vm-management"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
SRC_URI = "https://github.com/seapath/${BPN}/releases/download/v${PV}/${BPN}.tar.gz"
SRC_URI[sha256sum] = "643342d950916bc6023154f724fba0eae69ea555c867fd410cfb40c2db01a4ac"

S = "${UNPACKDIR}"

inherit allarch

do_install() {
    install -d ${D}${datadir}/cockpit/${PN}

    install -m 0644 ${S}/index.css ${D}${datadir}/cockpit/${PN}
    install -m 0644 ${S}/index.html ${D}${datadir}/cockpit/${PN}
    install -m 0644 ${S}/index.js ${D}${datadir}/cockpit/${PN}
    install -m 0644 ${S}/manifest.json ${D}${datadir}/cockpit/${PN}
}

FILES:${PN} += "${datadir}/cockpit/${PN}"
RDEPENDS:${PN} += "cockpit"
