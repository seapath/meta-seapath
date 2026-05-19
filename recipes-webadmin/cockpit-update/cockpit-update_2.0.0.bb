# Copyright (C) 2025-2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "cockpit cluster update"
DESCRIPTION = "Swupdate cockpit plugin for SEAPATH project"
HOMEPAGE = "https://github.com/seapath/cockpit-update"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
SRC_URI = "https://github.com/seapath/${BPN}/releases/download/v${PV}/${BPN}.tar.gz"
SRC_URI[sha256sum] = "80a32275d1e24933b4502535d928a387158e8590a374a71a9d3ca952ccda9834"

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
