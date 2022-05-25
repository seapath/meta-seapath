# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

do_install_append() {
    install -m 0755 -d ${D}/${sbindir}
    ln -s ${bindir}/dpdk-devbind.py ${D}/${sbindir}/dpdk-devbind

}

FILES_${PN}-tools += "${sbindir}/dpdk-devbind"
