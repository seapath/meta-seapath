# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "IRQ allocation daemon"
DESCRIPTION = "A daemon to balance interrupts across multiple CPUs, \
which can lead to better performance and IO balance on SMP systems."

HOMEPAGE = "https://irqbalance.github.io/irqbalance/;branch=master"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

SRCREV = "v${PV}"
S = "${WORKDIR}/git"

SRC_URI = " \
    git://github.com/Irqbalance/irqbalance \
    file://irqbalance.service \
"

DEPENDS = "glib-2.0"

inherit autotools pkgconfig systemd

SYSTEMD_PACKAGES = "irqbalance"
SYSTEMD_SERVICE_irqbalance = "irqbalance.service"

do_install_append () {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/irqbalance.service \
        ${D}${systemd_unitdir}/system/irqbalance.service
    sed -i -e 's/@RT_CORE_LIST@/${@d.getVar("SEAPATH_RT_CORES", "")}/g' \
        ${D}${systemd_unitdir}/system/irqbalance.service
}
