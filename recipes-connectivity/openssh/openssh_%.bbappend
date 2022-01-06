# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://sshd_config_seapath \
    file://sshd_config_seapath_flash \
    file://sshd_config_seapath_readonly \
"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','seapath-readonly','true','false',d)}; then
        install -d ${D}${sysconfdir}/ssh
        install -m 0644 ${WORKDIR}/sshd_config_seapath_readonly \
           ${D}${sysconfdir}/ssh/sshd_config
    elif ${@bb.utils.contains('DISTRO_FEATURES','seapath-security','true','false',d)}; then
        install -d ${D}${sysconfdir}/ssh
        install -m 0644 ${WORKDIR}/sshd_config_seapath \
           ${D}${sysconfdir}/ssh/sshd_config
    fi
}

do_install_append_seapath-flash() {
    install -d ${D}${sysconfdir}/ssh
    install -m 0644 ${WORKDIR}/sshd_config_seapath_flash \
        ${D}${sysconfdir}/ssh/sshd_config
}

FILES_${PN} += " \
    ${sysconfdir}/ssh/sshd_config \
"
