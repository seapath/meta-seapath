# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://sudoers\
"

do_install_append() {
    install -d ${D}${sysconfdir}
    install -m 0440 ${WORKDIR}/sudoers \
       ${D}${sysconfdir}/sudoers
}
