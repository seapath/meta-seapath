# Copyright (C) 2020, RTE (http://www.rte-france.com)

RDEPENDS_${PN} = "bash"

FILESEXTRAPATHS:prepend :="${THISDIR}/files:"

EXTRA_OECONF += "--with-mib-modules=ucd-snmp/diskio"

SRC_URI += " \
    file://snmp_crmstatus.sh \
"

do_install:append() {
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/snmp_crmstatus.sh ${D}/${bindir}/snmp_crmstatus.sh
}

FILES_${PN}-server += "${bindir}/snmp_crmstatus.sh"
