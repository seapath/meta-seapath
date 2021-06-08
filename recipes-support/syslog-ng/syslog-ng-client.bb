# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0
SUMMARY = "syslog-ng-client"
DESCRIPTION = "Client configuration for syslog-ng"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RCONFLICTS_${PN} = "syslog-ng-server"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://clientcert.pem \
    file://clientkey.pem \
    file://syslog-client-votp.conf.systemd \
"

do_install() {
    install -d ${D}${sysconfdir}/syslog-ng
    install -m 0644 ${WORKDIR}/syslog-client-votp.conf.systemd \
       ${D}${sysconfdir}/syslog-ng/syslog-ng.conf

    install -d ${D}${sysconfdir}/syslog-ng/cert.d
    install -m 0400 ${WORKDIR}/clientcert.pem \
        ${D}${sysconfdir}/syslog-ng/cert.d
    install -m 0400 ${WORKDIR}/clientkey.pem \
        ${D}${sysconfdir}/syslog-ng/cert.d
}

FILES_${PN} += " \
    ${sysconfdir}/syslog-ng/cert.d/clientcert.pem \
    ${sysconfdir}/syslog-ng/cert.d/clientkey.pem \
    ${sysconfdir}/syslog-ng/syslog-ng.conf \
"
