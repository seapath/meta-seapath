# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

inherit create-dirs

SERVICE_DIRS_LIST = "corosync"
SERVICE_DIRS_PREFIX = "{lib,log}"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://corosync.service \
    file://create-corosync-pid.service \
"

do_install:append() {
    install -d ${D}/${systemd_unitdir}/system/
    install -m 644 ${WORKDIR}/corosync.service \
        ${D}/${systemd_unitdir}/system/corosync.service
    install -m 0644 ${WORKDIR}/create-corosync-pid.service \
        ${D}/${systemd_unitdir}/system/create-corosync-pid.service
}

SYSTEMD_SERVICE:${PN} += " \
    create-corosync-pid.service \
"

FILES:${PN} += " \
    ${systemd_unitdir}/system/corosync.service \
    ${systemd_unitdir}/system/create-corosync-pid.service \
"
