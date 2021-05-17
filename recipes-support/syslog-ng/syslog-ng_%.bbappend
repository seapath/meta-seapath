# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

inherit log-dirs

DEPENDS += " openssl-native"

LOG_DIRS_LIST += " syslog-ng"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://cacert.pem \
    file://syslog-ng@.service \
"

do_install_append() {
    rm ${D}${sysconfdir}/${BPN}/syslog-ng.conf

    install -d ${D}${sysconfdir}/syslog-ng/ca.d
    install -m 0644 ${WORKDIR}/cacert.pem \
       ${D}${sysconfdir}/syslog-ng/ca.d
    hashconf=$(openssl x509 -noout -hash -in "${WORKDIR}/cacert.pem")
    ln -sf cacert.pem \
      ${D}${sysconfdir}/syslog-ng/ca.d/$hashconf.0

    install -d {D}{systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/syslog-ng@.service \
        ${D}${systemd_unitdir}/system
}

CONFFILES_${PN}_remove = "${sysconfdir}/${BPN}.conf"

SYSTEMD_SERVICE_${PN} += " \
    syslog-ng@.service \
"

FILES_${PN} += " \
    ${sysconfdir}/syslog-ng/ca.d/* \
    ${systemd_unitdir}/system/syslog-ng@.service \
"
