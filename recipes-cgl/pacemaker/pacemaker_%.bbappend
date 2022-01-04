# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

inherit create-dirs

SERVICE_DIRS_LIST = "pacemaker"
SERVICE_DIRS_PREFIX = "{log,lib}"
SERVICE_DIRS_OWNER = "hacluster:haclient"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://create-var-run-resource-agents.service \
    file://pacemaker.service \
"

do_install_append() {
    install -d ${D}/${systemd_unitdir}/system/
    install -m 644 ${WORKDIR}/create-var-run-resource-agents.service \
        ${D}/${systemd_unitdir}/system/create-var-run-resource-agents.service
    install -m 644 ${WORKDIR}/pacemaker.service \
        ${D}/${systemd_unitdir}/system/pacemaker.service
    install -d ${D}${sysconfdir}/tmpfiles.d
    echo "d /run/systemd/system/resource-agents-deps.target.d 0750 hacluster haclient -" >> ${D}${sysconfdir}/tmpfiles.d/pacemaker.conf
}

FILES_${PN} += " \
    ${systemd_unitdir}/system/create-var-run-resource-agents.service \
    ${systemd_unitdir}/system/pacemaker.service \
"
