# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://sshd_config \
    file://sshd_config_flash \
    file://sshd_config_readonly \
"

do_install_append() {
    install -d ${D}${sysconfdir}/ssh
    install -m 0644 ${WORKDIR}/sshd_config \
       ${D}${sysconfdir}/ssh
}

do_install_append_seapath-flash() {
    install -d ${D}${sysconfdir}/ssh
    install -m 0644 ${WORKDIR}/sshd_config_flash \
        ${D}${sysconfdir}/ssh/sshd_config
}

do_install_append_seapath-ro() {
    install -d ${D}${sysconfdir}/ssh
    install -m 0644 ${WORKDIR}/sshd_config_readonly \
       ${D}${sysconfdir}/ssh
}

FILES_${PN} += " \
    ${sysconfdir}/ssh/sshd_config \
"
