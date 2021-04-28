# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://syslog-client-votp.conf.systemd \
"

do_install_append() {
    install -d ${D}${sysconfdir}/${BPN}
    install -m 0644 ${WORKDIR}/syslog-client-votp.conf.systemd \
       ${D}${sysconfdir}/${BPN}/syslog-ng.conf
}

FILES_${PN} += " \
    ${sysconfdir}/${BPN}/syslog-ng.conf \
"
