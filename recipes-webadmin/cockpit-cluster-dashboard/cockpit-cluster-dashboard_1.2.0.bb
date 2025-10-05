# Copyright (C) 2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "cockpit cluster dashboard"
DESCRIPTION = "Cockpit plugin to manage virtual machines in a cluster environment."
HOMEPAGE = "https://github.com/seapath/cockpit-cluster-vm-management"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
SRC_URI = "https://github.com/seapath/${BPN}/releases/download/v${PV}/${BPN}.tar.gz"
SRC_URI[sha256sum] = "3e767d4ca0bec712d3e11a0b67eb628aa77c9195a4df649ee597a87423903814"

S = "${WORKDIR}"

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

