# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
    sed '/\[Service\]/a Environment="LC_ALL=en_US.UTF-8"' -i \
        ${D}${systemd_system_unitdir}/swupdate.service
}
