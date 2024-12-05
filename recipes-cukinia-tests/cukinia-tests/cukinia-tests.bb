# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "cukinia-tests"
DESCRIPTION = "Cukinia test files"
HOMEPAGE = "https://github.com/savoirfairelinux/cukinia"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit allarch

SRC_URI = "\
    file://cukinia-cluster.conf \
    file://cukinia-common.conf \
    file://cukinia.conf \
    file://cukinia-hypervisor.conf \
    file://cukinia-observer.conf \
    file://cukinia-sec.conf \
    file://cukinia-update.conf \
    file://cukinia-vm.conf \
    file://cluster_security_tests.d \
    file://cluster_tests.d \
    file://common_security_tests.d \
    file://common_tests.d \
    file://configurations \
    file://configurations-cluster \
    file://hypervisor_security_tests.d \
    file://hypervisor_tests.d \
    file://includes \
    file://observer_tests.d \
    file://update_tests.d \
    file://vm_tests.d \
"

RDEPENDS:${PN} += "cukinia"
RDEPENDS:${PN} += "bash coreutils pciutils"

install_dir () {
    SRC_DIR=$1
    DST_DIR=$2
    install -m 0755 -d ${DST_DIR}
    for file in ${SRC_DIR}/*; do
        install -m 0644 ${file} ${DST_DIR}
    done
}

do_install () {
    install -m 0755 -d ${D}${sysconfdir}/cukinia/
    install -m 0644 ${WORKDIR}/cukinia.conf ${D}${sysconfdir}/cukinia

# common
    install -m 0644 ${WORKDIR}/cukinia-common.conf \
        ${D}${sysconfdir}/cukinia/cukinia-common.conf
    install_dir ${WORKDIR}/common_tests.d \
        ${D}${sysconfdir}/cukinia/common_tests.d

    install -m 0755 -d ${D}${datadir}/cukinia/includes/
    install -m 0644 ${WORKDIR}/includes/kernel_config_functions \
        ${D}${datadir}/cukinia/includes/kernel_config_functions
    install -m 0755 -d  ${D}${sysconfdir}/cukinia/configurations/
    install -m 0644 ${WORKDIR}/configurations/cukinia-common.conf \
        ${D}${sysconfdir}/cukinia/configurations/

# common security
    install -m 0644 ${WORKDIR}/cukinia-sec.conf \
        ${D}${sysconfdir}/cukinia/
    install -m 0644 ${WORKDIR}/configurations/cukinia-common-security.conf \
        ${D}${sysconfdir}/cukinia/configurations/
    install_dir ${WORKDIR}/common_security_tests.d \
        ${D}${sysconfdir}/cukinia/common_security_tests.d

# hypervisor
    install -m 0644 ${WORKDIR}/cukinia-hypervisor.conf ${D}${sysconfdir}/cukinia
    install -m 0644 ${WORKDIR}/configurations/cukinia-hypervisor-common.conf \
        ${D}${sysconfdir}/cukinia/configurations/
    install_dir ${WORKDIR}/hypervisor_tests.d \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d

# hypervisor security
    install -m 0644 ${WORKDIR}/configurations/cukinia-hypervisor-security.conf \
        ${D}${sysconfdir}/cukinia/configurations/
    install_dir ${WORKDIR}/hypervisor_security_tests.d \
        ${D}${sysconfdir}/cukinia/hypervisor_security_tests.d

# observer
    install -m 0644 ${WORKDIR}/cukinia-observer.conf ${D}${sysconfdir}/cukinia
    install_dir ${WORKDIR}/observer_tests.d \
        ${D}${sysconfdir}/cukinia/observer_tests.d

# cluster
    install -m 0755 -d ${D}${sysconfdir}/cukinia/configurations-cluster
    install -m 0644 ${WORKDIR}/cukinia-cluster.conf \
        ${D}${sysconfdir}/cukinia/cukinia-cluster.conf
    install_dir ${WORKDIR}/cluster_tests.d \
        ${D}${sysconfdir}/cukinia/cluster_tests.d
    install -m 0644 ${WORKDIR}/configurations-cluster/cukinia-cluster-common.conf \
        ${D}${sysconfdir}/cukinia/configurations-cluster/cukinia-cluster-common.conf

# cluster security
    install_dir ${WORKDIR}/cluster_security_tests.d \
        ${D}${sysconfdir}/cukinia/cluster_security_tests.d
    install -m 0644 ${WORKDIR}/configurations-cluster/cukinia-cluster-security.conf \
        ${D}${sysconfdir}/cukinia/configurations-cluster/cukinia-cluster-security.conf

# vm
    install -m 0644 ${WORKDIR}/cukinia-vm.conf ${D}${sysconfdir}/cukinia
    install_dir ${WORKDIR}/vm_tests.d \
        ${D}${sysconfdir}/cukinia/vm_tests.d

# update
    install -m 0644 ${WORKDIR}/cukinia-update.conf ${D}${sysconfdir}/cukinia
    install_dir ${WORKDIR}/update_tests.d \
        ${D}${sysconfdir}/cukinia/update_tests.d
    install -m 0644 ${WORKDIR}/configurations/cukinia-update.conf \
        ${D}${sysconfdir}/cukinia/configurations/cukinia-update.conf
}

PACKAGES =+ " \
    ${PN}-cluster \
    ${PN}-cluster-security \
    ${PN}-common \
    ${PN}-common-security \
    ${PN}-hypervisor \
    ${PN}-hypervisor-readonly \
    ${PN}-hypervisor-security \
    ${PN}-hypervisor-iommu \
    ${PN}-observer \
    ${PN}-vm \
    ${PN}-update \
"

RDEPENDS:${PN}-vm += "${PN}-common"

FILES:${PN} = " \
    ${sysconfdir}/cukinia/cukinia.conf \
    ${datadir}/cukinia/includes \
"

FILES:${PN}-cluster = " \
    ${sysconfdir}/cukinia/cukinia-cluster.conf \
    ${sysconfdir}/cukinia/configurations-cluster/cukinia-cluster-common.conf \
    ${sysconfdir}/cukinia/cluster_tests.d/* \
"

FILES:${PN}-cluster-security = " \
    ${sysconfdir}/cukinia/configurations-cluster/cukinia-cluster-security.conf \
    ${sysconfdir}/cukinia/cluster_security_tests.d/* \
"

FILES:${PN}-common = " \
    ${sysconfdir}/cukinia/cukinia-common.conf \
    ${sysconfdir}/cukinia/configurations/cukinia-common.conf \
    ${sysconfdir}/cukinia/common_tests.d/* \
"

FILES:${PN}-common-security = " \
    ${sysconfdir}/cukinia/cukinia-sec.conf \
    ${sysconfdir}/cukinia/configurations/cukinia-common-security.conf \
    ${sysconfdir}/cukinia/common_security_tests.d/* \
"

FILES:${PN}-hypervisor = " \
    ${sysconfdir}/cukinia/cukinia-hypervisor.conf \
    ${sysconfdir}/cukinia/configurations/cukinia-hypervisor-common.conf \
    ${sysconfdir}/cukinia/hypervisor_tests.d/* \
"

FILES:${PN}-hypervisor-security = " \
    ${sysconfdir}/cukinia/configurations/cukinia-hypervisor-security.conf \
    ${sysconfdir}/cukinia/hypervisor_security_tests.d/* \
"

FILES:${PN}-observer = " \
    ${sysconfdir}/cukinia/cukinia-observer.conf \
    ${sysconfdir}/cukinia/observer_tests.d/* \
"

FILES:${PN}-vm = " \
    ${sysconfdir}/cukinia/cukinia-vm.conf \
    ${sysconfdir}/cukinia/vm_tests.d/* \
"

FILES:${PN}-update = " \
    ${sysconfdir}/cukinia/cukinia-update.conf \
    ${sysconfdir}/cukinia/update_tests.d/* \
    ${sysconfdir}/cukinia/configurations/cukinia-update.conf \
"
