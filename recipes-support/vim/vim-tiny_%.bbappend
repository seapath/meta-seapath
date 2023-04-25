# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://vimrc \
"

do_install:append() {
    install -d ${D}/${datadir}/vim/
    install -m 644 ${WORKDIR}/vimrc ${D}/${datadir}/vim/vimrc
}

FILES:${PN}:append = " ${datadir}/vim/vimrc"
