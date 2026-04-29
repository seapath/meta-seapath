# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# To enable the auto-flashing you have to define SEAPATH_AUTO_FLASH.
# See: https://github.com/seapath/yocto-bsp/blob/kirkstone/seapath.conf.sample

DESCRIPTION = "SEAPATH images flash script"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"
RDEPENDS:${PN} = "bash e2fsprogs-e2fsck e2fsprogs-resize2fs gptfdisk parted"

PACKAGES += "${PN}-auto"

inherit allarch

SRC_URI = " \
    file://auto-flash.sh.in \
    file://flash.sh \
    file://profile \
"

do_install () {
    install -d ${D}/${bindir}
    install -m 0755 ${UNPACKDIR}/flash.sh ${D}/${bindir}/flash
    install -m 0755 ${UNPACKDIR}/auto-flash.sh.in \
        ${D}${bindir}/auto-flash
    install -d -m 0700 ${D}/${ROOT_HOME}
    install -m 0644 ${UNPACKDIR}/profile ${D}/${ROOT_HOME}/.profile
    sed "s|@@SEAPATH_AUTO_FLASH@@|${SEAPATH_AUTO_FLASH}|" -i \
        ${D}${bindir}/auto-flash \
        ${D}/${ROOT_HOME}/.profile
}

FILES:${PN} = "${bindir}/flash"
FILES:${PN} += "${ROOT_HOME}/.profile"
FILES:${PN}-auto += "${bindir}/auto-flash"
