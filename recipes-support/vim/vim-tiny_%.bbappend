# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://vimrc \
    file://defaults.vim \
"

do_install:append() {
    install -d ${D}/${datadir}/vim/
    install -m 644 ${WORKDIR}/vimrc ${D}/${datadir}/vim/vimrc
    install -m 644 ${WORKDIR}/defaults.vim ${D}/${datadir}/vim/defaults.vim
}

FILES:${PN}:append = " \
    ${datadir}/vim/vimrc \
    ${datadir}/vim/defaults.vim \
"
