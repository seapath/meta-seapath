# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCREV = "0680912fba002e419170f63a3d66ac079fa7c427"
PV = "1.9.2+git${SRCPV}"

SRC_URI = " \
    git://github.com/Irqbalance/irqbalance;branch=master;protocol=https \
    file://irqbalanced.service \
"

do_install:append () {
    install -m 0644 ${WORKDIR}/irqbalanced.service \
         ${D}${systemd_unitdir}/system/irqbalanced.service
    sed -i -e 's/@RT_CORE_LIST@/${@d.getVar("SEAPATH_RT_CORES", "")}/g' \
        ${D}${systemd_unitdir}/system/irqbalanced.service
}
