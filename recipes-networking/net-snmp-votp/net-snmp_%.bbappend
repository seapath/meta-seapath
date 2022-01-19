# Copyright (C) 2020, RTE (http://www.rte-france.com)

RDEPENDS_${PN} = "bash"

FILESEXTRAPATHS:prepend :="${THISDIR}/files:"

EXTRA_OECONF += "--with-mib-modules=ucd-snmp/diskio"

SRC_URI += " \
    file://snmp_crmstatus.sh \
    file://snmp_domstats.sh \
    file://snmp_dommemstat.sh \
"

do_install:append() {
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/snmp_crmstatus.sh ${D}/${bindir}/snmp_crmstatus.sh
    install -m 0755 ${WORKDIR}/snmp_domstats.sh ${D}/${bindir}/snmp_domstats.sh
    install -m 0755 ${WORKDIR}/snmp_dommemstat.sh ${D}/${bindir}/snmp_dommemstat.sh
}

FILES_${PN}-server += "${bindir}/snmp_crmstatus.sh"
FILES_${PN}-server += "${bindir}/snmp_domstats.sh"
FILES_${PN}-server += "${bindir}/snmp_dommemstat.sh"
