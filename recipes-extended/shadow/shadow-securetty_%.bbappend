# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_install_append() {
    install -D -m 0400 ${WORKDIR}/securetty ${D}${sysconfdir}/securetty
}
