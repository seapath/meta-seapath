# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "The Corosync Cluster Engine Qdevice"
DESCRIPTION = "corosync-qdevice is a daemon running on each node of a cluster. \
It provides a configured number of votes to the quorum subsystem based on a \
third-party arbitrator's decision. Its primary use is to allow a cluster to \
sustain more node failures than standard quorum rules allow."
HOMEPAGE = "https://github.com/corosync/corosync-qdevice"
BUGTRACKER = "https://github.com/corosync/corosync-qdevice/issues"

CVE_PRODUCT = "corosync-qdevice corosync:corosync-qdevice"

SECTION = "base"

inherit autotools pkgconfig systemd

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=269da6ee9fc3cec5265effe22b48e187"

DEPENDS += "corosync nss"

SRC_URI = "https://github.com/corosync/${BPN}/releases/download/v${PV}/${BP}.tar.gz"

SRC_URI[sha256sum] = "0a4705abd17af795287ad3bb18c0abacf3c0027222e45f149cb9bebeb6056926"

SYSTEMD_SERVICE:${PN} = "corosync-qdevice.service"
SYSTEMD_SERVICE:corosync-qnetd = "corosync-qnetd.service"
SYSTEMD_AUTO_ENABLE = "disable"
SYSTEMD_AUTO_ENABLE:corosync-qnetd = "disable"

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'systemd', d)}"

PACKAGECONFIG[systemd] = "--enable-systemd --with-systemddir=${systemd_system_unitdir},--disable-systemd --without-systemddir,systemd"

EXTRA_OECONF = "ac_cv_path_BASHPATH=${base_bindir}/bash --enable-user-flags"

PACKAGES =+ "corosync-qnetd corosync-qnetd-doc"

do_install:append() {
    rm -rf ${D}${localstatedir}/run
}

FILES:corosync-qnetd = "\
    ${bindir}/corosync-qnetd \
    ${bindir}/corosync-qnetd-certutil \
    ${bindir}/corosync-qnetd-tool \
    ${sysconfdir}/corosync/qnetd \
    ${sysconfdir}/init.d/corosync-qnetd \
    ${systemd_system_unitdir}/corosync-qnetd.service \
"

FILES:corosync-qnetd-doc = "\
    ${mandir}/man8/corosync-qnetd.8 \
    ${mandir}/man8/corosync-qnetd-certutil.8 \
    ${mandir}/man8/corosync-qnetd-tool.8 \
"

RDEPENDS:${PN} += "bash ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'sysvinit-pidof', 'procps', d)}"
RDEPENDS:corosync-qnetd += "bash ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'sysvinit-pidof', 'procps', d)}"
