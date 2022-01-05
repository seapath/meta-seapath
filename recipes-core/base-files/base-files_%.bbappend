# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://nsswitch.conf"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','seapath-security','true','false',d)}; then
        install -m 755 -d ${D}/etc/
        install -m 644 ${WORKDIR}/nsswitch.conf ${D}/etc/
    fi
}
