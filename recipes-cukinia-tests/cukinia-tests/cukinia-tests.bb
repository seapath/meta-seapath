# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "cukinia-tests"
DESCRIPTION = "Cukinia test files"
HOMEPAGE = "https://github.com/savoirfairelinux/cukinia"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
SRC_URI = "\
    file://cukinia.conf \
    file://cukinia-cluster.conf \
    file://cukinia-common.conf \
    file://cukinia-hypervisor.conf \
    file://cukinia-vm.conf \
    file://common_tests.d/cukinia-installation.conf \
    file://common_tests.d/sw-versions.conf \
    file://common_tests.d/preempt-rt.conf \
    file://common_tests.d/container.conf \
    file://common_tests.d/systemd.conf \
    file://cluster_tests.d/pacemaker.conf \
    file://cluster_tests.d/ceph.conf \
    file://hypervisor_tests.d/virtualization.conf \
    file://hypervisor_tests.d/ovs.conf \
    file://hypervisor_tests.d/ceph.conf \
"

RDEPENDS_${PN} += "cukinia"
RDEPENDS_${PN} += "bash coreutils pciutils"

do_install () {
    install -m 0755 -d ${D}${sysconfdir}/cukinia/
    install -m 0644 ${WORKDIR}/cukinia.conf ${D}${sysconfdir}/cukinia

# cluster
    install -m 0755 -d ${D}${sysconfdir}/cukinia/cluster_tests.d/
    install -m 0644 ${WORKDIR}/cukinia-cluster.conf \
        ${D}${sysconfdir}/cukinia/cukinia-cluster.conf
    install -m 0644 ${WORKDIR}/cluster_tests.d/pacemaker.conf \
        ${D}${sysconfdir}/cukinia/cluster_tests.d
    install -m 0644 ${WORKDIR}/cluster_tests.d/ceph.conf \
        ${D}${sysconfdir}/cukinia/cluster_tests.d

# common
    install -m 0755 -d ${D}${sysconfdir}/cukinia/common_tests.d/
    install -m 0644 ${WORKDIR}/cukinia-common.conf \
        ${D}${sysconfdir}/cukinia/cukinia-common.conf
    install -m 0644 ${WORKDIR}/common_tests.d/cukinia-installation.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d
    install -m 0644 ${WORKDIR}/common_tests.d/sw-versions.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d
    install -m 0644 ${WORKDIR}/common_tests.d/preempt-rt.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d
    install -m 0644 ${WORKDIR}/common_tests.d/systemd.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d

# hypervisor
    install -m 0755 -d ${D}${sysconfdir}/cukinia/hypervisor_tests.d/
    install -m 0644 ${WORKDIR}/cukinia-hypervisor.conf ${D}${sysconfdir}/cukinia
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/virtualization.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/ovs.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/ceph.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d

# vm
    install -m 0644 ${WORKDIR}/cukinia-vm.conf ${D}${sysconfdir}/cukinia
}



PACKAGES =+ "${PN}-cluster ${PN}-hypervisor ${PN}-common ${PN}-vm"

RDEPENDS_${PN}-vm += "${PN}-common"

FILES_${PN} = " \
    ${sysconfdir}/cukinia/cukinia.conf \
"


FILES_${PN}-cluster = " \
    ${sysconfdir}/cukinia/cukinia-cluster.conf \
    ${sysconfdir}/cukinia/cluster_tests.d/* \
"

FILES_${PN}-common = " \
    ${sysconfdir}/cukinia/cukinia-common.conf \
    ${sysconfdir}/cukinia/common_tests.d/* \
"

FILES_${PN}-hypervisor = " \
    ${sysconfdir}/cukinia/cukinia-hypervisor.conf \
    ${sysconfdir}/cukinia/hypervisor_tests.d/* \
"

FILES_${PN}-vm = " \
    ${sysconfdir}/cukinia/cukinia-vm.conf \
"
