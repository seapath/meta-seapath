# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DEPENDS += " openssl-native"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://cacert.pem \
"

do_install_append() {
    rm ${D}${sysconfdir}/${BPN}/syslog-ng.conf

    install -d ${D}${sysconfdir}/syslog-ng/ca.d
    install -m 0644 ${WORKDIR}/cacert.pem \
       ${D}${sysconfdir}/syslog-ng/ca.d
    hashconf=$(openssl x509 -noout -hash -in "${WORKDIR}/cacert.pem")
    ln -sf cacert.pem \
      ${D}${sysconfdir}/syslog-ng/ca.d/$hashconf.0
}

CONFFILES_${PN}_remove = "${sysconfdir}/${BPN}.conf"

FILES_${PN} += " \
    ${sysconfdir}/syslog-ng/ca.d/* \
"
