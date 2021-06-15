# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Votp System configuration"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"
RDEPENDS_${PN} = "bash udev"

SRC_URI = " \
    file://is_from_inactive_bank.sh \
    file://partition_symlinks.rules \
    file://switch_bootloader.sh \
"

do_install () {
    install -d ${D}${bindir}
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0755 ${WORKDIR}/is_from_inactive_bank.sh \
        ${D}${bindir}/is_from_inactive_bank
    install -m 0644 ${WORKDIR}/partition_symlinks.rules \
        ${D}${sysconfdir}/udev/rules.d
    install -m 0755 ${WORKDIR}/switch_bootloader.sh \
        ${D}${bindir}/switch_bootloader
}

FILES_${PN} = " \
    ${sysconfdir}/udev/rules.d/partition_symlinks.rules \
    ${bindir}/is_from_inactive_bank \
    ${bindir}/switch_bootloader \
"
