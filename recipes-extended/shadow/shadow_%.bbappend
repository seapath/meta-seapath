# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://login.defs \
"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','seapath-security','true','false',d)}; then
        install -d ${D}${sysconfdir}
        install -m 0644 ${WORKDIR}/login.defs \
           ${D}${sysconfdir}
    fi
}
