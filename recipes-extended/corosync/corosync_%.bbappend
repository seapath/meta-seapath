# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://corosync.service \
    file://create-corosync-pid.service \
"

do_install_append() {
    install -d ${D}/${systemd_unitdir}/system/
    install -m 644 ${WORKDIR}/corosync.service \
        ${D}/${systemd_unitdir}/system/corosync.service
    install -m 0644 ${WORKDIR}/create-corosync-pid.service \
        ${D}/${systemd_unitdir}/system/create-corosync-pid.service
}

SYSTEMD_SERVICE_${PN} += " \
    create-corosync-pid.service \
"

FILES_${PN} += " \
    ${systemd_unitdir}/system/corosync.service \
    ${systemd_unitdir}/system/create-corosync-pid.service \
"
