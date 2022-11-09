# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

EXTRA_OECONF += "--with-mib-modules=ucd-snmp/diskio"

do_install:append() {
    echo "includeDir ${sysconfdir}/snmp/config.d" > ${D}${sysconfdir}/snmp/snmpd.conf
}
