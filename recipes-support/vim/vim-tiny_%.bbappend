# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://vimrc \
"

do_install_append() {
    install -d ${D}/${datadir}/vim/
    install -m 644 ${WORKDIR}/vimrc ${D}/${datadir}/vim/vimrc
}

FILES_${PN}_append = " ${datadir}/vim/vimrc"
