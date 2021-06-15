# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://pacemaker.service \
"

do_install_append() {
    install -d ${D}/${systemd_unitdir}/system/
    install -m 644 ${WORKDIR}/pacemaker.service \
        ${D}/${systemd_unitdir}/system/pacemaker.service
}

FILES_${PN} += " \
    ${systemd_unitdir}/system/pacemaker.service \
"
