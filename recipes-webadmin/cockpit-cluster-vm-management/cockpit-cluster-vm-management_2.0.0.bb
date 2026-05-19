# Copyright (C) 2025-2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "cockpit cluster vm management"
DESCRIPTION = "Cockpit plugin to manage VMs inside a SEAPATH cluster"
HOMEPAGE = "https://github.com/seapath/cockpit-cluster-vm-management"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
SRC_URI = "https://github.com/seapath/${BPN}/releases/download/v${PV}/${BPN}.tar.gz"
SRC_URI[sha256sum] = "8288872fa6412f2b67f3cf12c7d20fb455aec10bf4d9b746068dda64611d5266"

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
