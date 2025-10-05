# Copyright (C) 2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "cockpit cluster update"
DESCRIPTION = "Swupdate cockpit plugin for SEAPATH project"
HOMEPAGE = "https://github.com/seapath/cockpit-update"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
SRC_URI = "https://github.com/seapath/${BPN}/releases/download/v${PV}/${BPN}.tar.gz"
SRC_URI[sha256sum] = "67a66be9aad650f7e83a71ac76adc38deaa1dc6927678325a2d7aa4018006ad7"

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
