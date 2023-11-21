# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCREV = "0680912fba002e419170f63a3d66ac079fa7c427"
PV = "1.9.2+git${SRCPV}"

SRC_URI = " \
    git://github.com/Irqbalance/irqbalance;branch=master;protocol=https \
    file://irqbalanced.service \
    file://set_irq_max_core.sh \
    file://irqbalance.env \
"

RDEPENDS:${PN} += "bash coreutils"

do_install:append () {
    install -m 0644 ${WORKDIR}/irqbalanced.service \
         ${D}${systemd_unitdir}/system/irqbalanced.service

    install -d ${D}${libexecdir}
    install -m 0755 ${WORKDIR}/set_irq_max_core.sh ${D}${libexecdir}/set_irq_max_core.sh

    install -d ${D}/${sysconfdir}
    install -m 0755 ${WORKDIR}/irqbalance.env ${D}${sysconfdir}/irqbalance.env

    sed -i -e 's/@RT_CORE_LIST@/${SEAPATH_RT_CORES}/g' \
        ${D}${sysconfdir}/irqbalance.env
}
