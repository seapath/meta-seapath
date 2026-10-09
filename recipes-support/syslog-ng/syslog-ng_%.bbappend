# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

inherit create-dirs

DEPENDS += " openssl-native"

SERVICE_DIRS_LIST += " syslog-ng"
SERVICE_DIRS_PREFIX = "log"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://syslog-ng@default \
    file://syslog-ng@.service \
"

do_install:append() {
    rm ${D}${sysconfdir}/${BPN}/syslog-ng.conf

    install -d {D}{systemd_unitdir}/system
    install -m 0644 ${UNPACKDIR}/syslog-ng@.service \
        ${D}${systemd_unitdir}/system

    install -d ${D}{sysconfdir}/default
    install -m 0644 ${UNPACKDIR}/syslog-ng@default \
        ${D}${sysconfdir}/default
}

FILES:${PN} += " \
    ${sysconfdir}/default/syslog-ng@default \
    ${systemd_unitdir}/system/syslog-ng@.service \
"
