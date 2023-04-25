# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

inherit create-dirs

DEPENDS += " openssl-native"

SERVICE_DIRS_LIST += " syslog-ng"
SERVICE_DIRS_PREFIX = "log"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://cacert.pem \
    file://syslog-ng@default \
    file://syslog-ng@.service \
"

do_install:append() {
    rm ${D}${sysconfdir}/${BPN}/syslog-ng.conf

    install -d ${D}${sysconfdir}/syslog-ng/ca.d
    install -m 0400 ${WORKDIR}/cacert.pem \
       ${D}${sysconfdir}/syslog-ng/ca.d
    hashconf=$(openssl x509 -noout -hash -in "${WORKDIR}/cacert.pem")
    ln -sf cacert.pem \
      ${D}${sysconfdir}/syslog-ng/ca.d/$hashconf.0
    chmod 0400 ${D}${sysconfdir}/syslog-ng/ca.d/$hashconf.0

    install -d {D}{systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/syslog-ng@.service \
        ${D}${systemd_unitdir}/system

    install -d ${D}{sysconfdir}/default
    install -m 0644 ${WORKDIR}/syslog-ng@default \
        ${D}${sysconfdir}/default
}

CONFFILES:${PN}:remove = "${sysconfdir}/${BPN}.conf"

SYSTEMD_SERVICE:${PN} += " \
    syslog-ng@.service \
"

FILES:${PN} += " \
    ${sysconfdir}/syslog-ng/ca.d/* \
    ${sysconfdir}/default/syslog-ng@default \
    ${systemd_unitdir}/system/syslog-ng@.service \
"
