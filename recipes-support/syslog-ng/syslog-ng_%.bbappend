# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

inherit create-dirs

DEPENDS += " openssl-native"

SERVICE_DIRS_LIST += " syslog-ng"
SERVICE_DIRS_PREFIX = "log"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://syslog-ng-seapath@default \
    file://10-seapath.conf \
    file://20-hardening.conf \
"

do_install:append() {
    rm ${D}${sysconfdir}/${BPN}/syslog-ng.conf

    install -d ${D}/${systemd_system_unitdir}/syslog-ng@.service.d
    install -m 0644 ${UNPACKDIR}/10-seapath.conf \
        ${D}/${systemd_system_unitdir}/syslog-ng@.service.d
    install -m 0644 ${UNPACKDIR}/20-hardening.conf \
        ${D}/${systemd_system_unitdir}/syslog-ng@.service.d

    install -d ${D}{sysconfdir}/default
    install -m 0644 ${UNPACKDIR}/syslog-ng-seapath@default \
        ${D}${sysconfdir}/default
}

FILES:${PN} += " \
    ${systemd_system_unitdir}/syslog-ng@.service.d \
"
