# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DEPENDS += " openssl-native"

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

    rm -r ${D}${systemd_unitdir}/system/multi-user.target.wants
}

FILES:${PN} += " \
    ${systemd_system_unitdir}/syslog-ng@.service.d \
"

SYSTEMD_SERVICE:${PN}:remove = "${BPN}@.service"
FILES:${PN}:remove = "${systemd_unitdir}/system/multi-user.target.wants/*"
