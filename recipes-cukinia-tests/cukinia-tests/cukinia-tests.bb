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
    file://cukinia-monitor.conf \
    file://cukinia-realtime.conf \
    file://cukinia-vm.conf \
    file://common_tests.d/cukinia-installation.conf \
    file://common_tests.d/sw-versions.conf \
    file://common_tests.d/preempt-rt.conf \
    file://common_tests.d/container.conf \
    file://common_tests.d/systemd.conf \
    file://common_tests.d/sysctl.conf \
    file://common_tests.d/kernel.conf \
    file://common_tests.d/kernel_errors.conf \
    file://common_tests.d/syslog.conf \
    file://common_tests.d/hardening.conf \
    file://common_tests.d/sudo.conf \
    file://common_tests.d/files.conf \
    file://common_tests.d/partition-symlinks.conf \
    file://cluster_tests.d/pacemaker.conf \
    file://cluster_tests.d/ceph.conf \
    file://cluster_tests.d/vm_manager_libvirt.conf \
    file://cluster_tests.d/vm_manager_pacemaker.conf \
    file://cluster_tests.d/vm_manager_rbd.conf \
    file://cluster_tests.d/corosync.conf \
    file://hypervisor_tests.d/iommu.conf \
    file://hypervisor_tests.d/virtualization.conf \
    file://hypervisor_tests.d/ovs.conf \
    file://hypervisor_tests.d/ceph.conf \
    file://hypervisor_tests.d/kernel.conf \
    file://hypervisor_tests.d/spectre_mitigations.conf \
    file://hypervisor_tests.d/users.conf \
    file://hypervisor_tests.d/groups.conf \
    file://hypervisor_tests.d/passwd.conf \
    file://hypervisor_tests.d/shadow.conf \
    file://hypervisor_tests.d/auditd.conf \
    file://hypervisor_tests.d/libvirt.conf \
    file://hypervisor_tests.d/files.conf \
    file://monitor_tests.d/files.conf \
    file://vm_tests.d/files.conf \
    file://includes/kernel_config_functions \
    file://realtime_tests.d/cyclictest.conf \
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
    install -m 0644 ${WORKDIR}/cluster_tests.d/vm_manager_libvirt.conf \
        ${D}${sysconfdir}/cukinia/cluster_tests.d
    install -m 0644 ${WORKDIR}/cluster_tests.d/vm_manager_rbd.conf \
        ${D}${sysconfdir}/cukinia/cluster_tests.d
    install -m 0644 ${WORKDIR}/cluster_tests.d/vm_manager_pacemaker.conf \
        ${D}${sysconfdir}/cukinia/cluster_tests.d
    install -m 0644 ${WORKDIR}/cluster_tests.d/corosync.conf \
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
    install -m 0644 ${WORKDIR}/common_tests.d/kernel_errors.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d
    install -m 0644 ${WORKDIR}/common_tests.d/kernel.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d
    install -m 0644 ${WORKDIR}/common_tests.d/syslog.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d
    install -m 0644 ${WORKDIR}/common_tests.d/sysctl.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d
    install -m 0644 ${WORKDIR}/common_tests.d/hardening.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d
    install -m 0644 ${WORKDIR}/common_tests.d/sudo.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d
    install -m 0644 ${WORKDIR}/common_tests.d/files.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d
    install -m 0644 ${WORKDIR}/common_tests.d/partition-symlinks.conf \
        ${D}${sysconfdir}/cukinia/common_tests.d

    install -m 0755 -d ${D}${datadir}/cukinia/includes/
    install -m 0644 ${WORKDIR}/includes/kernel_config_functions \
        ${D}${datadir}/cukinia/includes/kernel_config_functions

# hypervisor
    install -m 0755 -d ${D}${sysconfdir}/cukinia/hypervisor_tests.d/
    install -m 0644 ${WORKDIR}/cukinia-hypervisor.conf ${D}${sysconfdir}/cukinia
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/iommu.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/virtualization.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/ovs.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/ceph.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/kernel.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/spectre_mitigations.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/users.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/groups.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/passwd.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/shadow.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/auditd.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/libvirt.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d
    install -m 0644 ${WORKDIR}/hypervisor_tests.d/files.conf \
        ${D}${sysconfdir}/cukinia/hypervisor_tests.d

# monitor
    install -m 0755 -d ${D}${sysconfdir}/cukinia/monitor_tests.d/
    install -m 0644 ${WORKDIR}/cukinia-monitor.conf ${D}${sysconfdir}/cukinia
    install -m 0644 ${WORKDIR}/monitor_tests.d/files.conf \
        ${D}${sysconfdir}/cukinia/monitor_tests.d

# realtime
    install -m 0755 -d ${D}${sysconfdir}/cukinia/realtime_tests.d/
    install -m 0644 ${WORKDIR}/cukinia-realtime.conf ${D}${sysconfdir}/cukinia
    install -m 0644 ${WORKDIR}/realtime_tests.d/cyclictest.conf \
        ${D}${sysconfdir}/cukinia/realtime_tests.d

# vm
    install -m 0644 ${WORKDIR}/cukinia-vm.conf ${D}${sysconfdir}/cukinia
    install -m 0755 -d ${D}${sysconfdir}/cukinia/vm_tests.d/
    install -m 0644 ${WORKDIR}/vm_tests.d/files.conf \
        ${D}${sysconfdir}/cukinia/vm_tests.d
}

PACKAGES =+ " \
    ${PN}-cluster \
    ${PN}-common \
    ${PN}-hypervisor \
    ${PN}-monitor \
    ${PN}-realtime \
    ${PN}-vm \
"

RDEPENDS_${PN}-realtime += "rt-tests"
RDEPENDS_${PN}-vm += "${PN}-common"

FILES_${PN} = " \
    ${sysconfdir}/cukinia/cukinia.conf \
    ${datadir}/cukinia/includes \
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

FILES_${PN}-monitor = " \
    ${sysconfdir}/cukinia/cukinia-monitor.conf \
    ${sysconfdir}/cukinia/monitor_tests.d/* \
"

FILES_${PN}-realtime = " \
    ${sysconfdir}/cukinia/cukinia-realtime.conf \
    ${sysconfdir}/cukinia/realtime_tests.d/* \
"

FILES_${PN}-vm = " \
    ${sysconfdir}/cukinia/cukinia-vm.conf \
    ${sysconfdir}/cukinia/vm_tests.d/* \
"
