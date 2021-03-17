# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "cukinia-tests"
DESCRIPTION = "Cukinia test files"
HOMEPAGE = "https://github.com/savoirfairelinux/cukinia"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
SRC_URI = "\
    file://cukinia.conf \
    file://tests.d/00-cukinia-installation.conf \
    file://tests.d/01-sw-versions.conf \
    file://tests.d/02-preempt-rt.conf \
    file://tests.d/03-no-kernel-errors.conf \
    file://tests.d/04-virtualization.conf \
    file://tests.d/05-container.conf \
    file://tests.d/06-ovs.conf \
    file://tests.d/07-systemd.conf \
    file://cluster_tests.d/01-pacemaker.conf \
    file://cluster_tests.d/02-ceph.conf \
"
RDEPENDS_${PN} += "cukinia"
RDEPENDS_${PN} += "bash coreutils pciutils"
do_install () {
    install -m 0755 -d ${D}${sysconfdir}/cukinia/
    install -m 0755 -d ${D}${sysconfdir}/cukinia/tests.d/
    install -m 0755 -d ${D}${sysconfdir}/cukinia/cluster_tests.d/
    install -m 0644 ${WORKDIR}/cukinia.conf ${D}${sysconfdir}/cukinia
    install -m 0644 ${WORKDIR}/tests.d/00-cukinia-installation.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/tests.d/01-sw-versions.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/tests.d/02-preempt-rt.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/tests.d/03-no-kernel-errors.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/tests.d/04-virtualization.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/tests.d/05-container.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/tests.d/06-ovs.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/tests.d/07-systemd.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/cluster_tests.d/01-pacemaker.conf \
        ${D}${sysconfdir}/cukinia/cluster_tests.d/
    install -m 0644 ${WORKDIR}/cluster_tests.d/02-ceph.conf \
        ${D}${sysconfdir}/cukinia/cluster_tests.d/
}
