# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

do_install_append() {
    rm ${D}${sysconfdir}/${BPN}/syslog-ng.conf
}

CONFFILES_${PN}_remove = "${sysconfdir}/${BPN}.conf"
