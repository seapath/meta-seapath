# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://common-password \
"

do_install_append() {
    install -d ${D}${sysconfdir}/pam.d
    install -m 0644 ${WORKDIR}/common-password \
       ${D}${sysconfdir}/pam.d
}

FILES_${PN} += " \
    ${sysconfdir}/pam.d/common-password \
"
