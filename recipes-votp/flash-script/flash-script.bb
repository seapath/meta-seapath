# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# To enable the auto-flashing you have to define SEAPATH_AUTO_FLASH.
# See: https://github.com/seapath/yocto-bsp/blob/kirkstone/seapath.conf.sample

DESCRIPTION = "Seapath images flash script"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"
RDEPENDS:${PN} = "bash"

PACKAGES += "${PN}-auto"

inherit allarch

SRC_URI = " \
    file://auto-flash.sh.in \
    file://flash.sh \
    file://profile \
"

do_install () {
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/flash.sh ${D}/${bindir}/flash
    install -d -m 0700 ${D}/${ROOT_HOME}
    install -m 0644 ${WORKDIR}/profile ${D}/${ROOT_HOME}/.profile
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/auto-flash.sh.in \
        ${D}${sysconfdir}/init.d/auto-flash.sh
    sed "s/@@SEAPATH_AUTO_FLASH@@/${SEAPATH_AUTO_FLASH}/" -i \
        ${D}${sysconfdir}/init.d/auto-flash.sh
}

FILES:${PN} = "${bindir}/flash"
FILES:${PN} += "${ROOT_HOME}/.profile"
FILES:${PN}-auto += "${sysconfdir}/init.d/auto-flash.sh"

inherit update-rc.d
INITSCRIPT_PACKAGES = "${PN}-auto"
INITSCRIPT_NAME:${PN}-auto = "auto-flash.sh"
INITSCRIPT_PARAMS:${PN}-auto = "start 99 2 3 4 5 ."
