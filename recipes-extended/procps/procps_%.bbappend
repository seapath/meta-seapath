# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

CONFFILES_${PN}_remove = "${sysconfdir}/sysctl.conf"

do_install_append() {
    rm -f ${D}${sysconfdir}/sysctl.conf
    rm -f ${D}${sysconfdir}/sysctl.d/99-sysctl.conf
}
