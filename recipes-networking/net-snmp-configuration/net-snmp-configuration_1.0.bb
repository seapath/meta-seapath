# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "snmpd SEAPATH configuration files"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RDEPENDS:${PN} = "net-snmp bash"
RDEPENDS:${PN}-cluster = "net-snmp bash ${PN} ${PN}-virtualization"
RDEPENDS:${PN}-virtualization = "net-snmp bash ${PN}"

FILESEXTRAPATHS:prepend :="${THISDIR}/files:"

PACKAGES += "${PN}-cluster ${PN}-virtualization"

S = "${WORKDIR}"

# Create snmp user
inherit useradd
USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = " \
    --system \
    --no-create-home \
    --home-dir ${localstatedir}/lib/snmp \
    --shell ${base_sbindir}/nologin \
    --user-group \
    --comment 'SNMP server daemon' \
    snmp \
"

# Add snmp's groups
inherit extrausers
EXTRA_USERS_PARAMS += "${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', 'usermod -a -G privileged,haclient snmp', '', d)}"
EXTRA_USERS_PARAMS += "${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'usermod -a -G libvirt snmp', '', d)}"

SRC_URI = " \
    file://cluster.conf \
    file://common.conf \
    file://libvirt.conf \
    file://net-snmp-service.conf \
    file://snmp \
    file://snmp_crmstatus.sh \
    file://snmp_domstats.sh \
    file://snmp_dommemstat.sh \
    file://snmp_diskusage.sh \
    file://virt-df.sh \
"

do_install() {
    install -d ${D}/${sysconfdir}/snmp/config.d
    install -m 0644 ${WORKDIR}/common.conf ${D}/${sysconfdir}/snmp/config.d/common.conf
    install -m 0644 ${WORKDIR}/libvirt.conf ${D}/${sysconfdir}/snmp/config.d/libvirt.conf
    install -m 0644 ${WORKDIR}/cluster.conf ${D}/${sysconfdir}/snmp/config.d/cluster.conf
    install -d ${D}/${libexecdir}
    install -m 0744 -o snmp -g snmp ${WORKDIR}/snmp_domstats.sh ${D}/${libexecdir}/snmp_domstats.sh
    install -m 0744 -o snmp -g snmp  ${WORKDIR}/snmp_dommemstat.sh ${D}/${libexecdir}/snmp_dommemstat.sh
    install -m 0744 -o snmp -g snmp ${WORKDIR}/snmp_crmstatus.sh ${D}/${libexecdir}/snmp_crmstatus.sh
    install -m 0744 -o snmp -g snmp  ${WORKDIR}/snmp_diskusage.sh ${D}/${libexecdir}/snmp_diskusage.sh
    install -m 0744 -o snmp -g snmp  ${WORKDIR}/virt-df.sh ${D}/${libexecdir}/virt-df.sh
    install -d -m 0750 ${D}/${sysconfdir}/sudoers.d
    install -m 0440 ${WORKDIR}/snmp ${D}/${sysconfdir}/sudoers.d/snmp
    install -d ${D}/${sysconfdir}/default
    install -m 0644 ${WORKDIR}/net-snmp-service.conf ${D}/${sysconfdir}/default/snmpd
}

FILES:${PN} = " \
    ${sysconfdir}/snmp/config.d/common.conf \
    ${sysconfdir}/default/snmpd \
"

FILES:${PN}-virtualization = " \
    ${sysconfdir}/snmp/config.d/libvirt.conf \
    ${libexecdir}/snmp_domstats.sh \
    ${libexecdir}/snmp_dommemstat.sh \
"

FILES:${PN}-cluster = " \
    ${sysconfdir}/snmp/config.d/cluster.conf \
    ${libexecdir}/snmp_diskusage.sh \
    ${libexecdir}/snmp_crmstatus.sh \
    ${libexecdir}/virt-df.sh \
    ${sysconfdir}/sudoers.d/snmp \
"

