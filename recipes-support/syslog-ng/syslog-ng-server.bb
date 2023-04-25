# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0
SUMMARY = "syslog-ng-server"
DESCRIPTION = "Server configuratioin for syslog-ng"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RCONFLICTS:${PN} = "syslog-ng-client"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://servercert.pem \
    file://serverkey.pem \
    file://syslog-server-votp.conf.systemd \
"

do_install() {
    install -d ${D}${sysconfdir}/syslog-ng
    install -m 0644 ${WORKDIR}/syslog-server-votp.conf.systemd \
       ${D}${sysconfdir}/syslog-ng/syslog-ng.conf

    install -d ${D}${sysconfdir}/syslog-ng/cert.d
    install -m 0400 ${WORKDIR}/servercert.pem \
        ${D}${sysconfdir}/syslog-ng/cert.d
    install -m 0400 ${WORKDIR}/serverkey.pem \
        ${D}${sysconfdir}/syslog-ng/cert.d
}

FILES:${PN} += " \
    ${sysconfdir}/syslog-ng/cert.d/servercert.pem \
    ${sysconfdir}/syslog-ng/cert.d/serverkey.pem \
    ${sysconfdir}/syslog-ng/syslog-ng.conf \
"
