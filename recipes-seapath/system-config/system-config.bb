# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Seapath System configuration"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"
RDEPENDS:${PN}-security = "bash"
RDEPENDS:${PN}-common= "${PN}-keymap"

SRC_URI = " \
    file://common/10-erspan0.network \
    file://common/10-gretap0.network \
    file://common/90-sysctl-hardening.conf \
    file://common/99-sysctl-network.conf \
    file://common/terminal_idle.sh \
    file://common/var-log.mount \
    file://host/enable-rt-runtime-share.sh \
    file://host/hugetlb-gigantic-pages.service \
    file://host/hugetlb-reserve-pages.sh \
    file://host/rt-runtime-share.service \
    file://security/disable-local-login.sh \
    file://test/usb-cdc-acm.conf \
"

do_install () {
    install -d ${D}/${sbindir}
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}${sysconfdir}/sysconfig

# Common
    install -d ${D}${sysconfdir}/sysctl.d
    install -m 0644 ${WORKDIR}/common/99-sysctl-network.conf \
        ${D}${sysconfdir}/sysctl.d
    install -m 0644 ${WORKDIR}/common/var-log.mount \
        ${D}${systemd_unitdir}/system

# keymap
    if [ -z "${SEAPATH_KEYMAP}" ] ; then
         SEAPATH_KEYMAP=us
    fi
    echo "KEYMAP=\"${SEAPATH_KEYMAP}\"" > ${D}${sysconfdir}/vconsole.conf

# Host
    install -m 0644 ${WORKDIR}/host/hugetlb-gigantic-pages.service \
        ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/host/hugetlb-reserve-pages.sh \
        ${D}/${sbindir}

    install -m 0644 ${WORKDIR}/host/rt-runtime-share.service \
        ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/host/enable-rt-runtime-share.sh \
        ${D}/${sbindir}/

# Security
    install -m 0755 ${WORKDIR}/security/disable-local-login.sh \
        ${D}/${sbindir}
    install -d ${D}${sysconfdir}/profile.d
    install -m 0644 ${WORKDIR}/common/terminal_idle.sh \
        ${D}${sysconfdir}/profile.d
    install -m 0644 ${WORKDIR}/common/90-sysctl-hardening.conf \
        ${D}${sysconfdir}/sysctl.d

# Network
    install -d ${D}${systemd_unitdir}/network
    install -m 0644 ${WORKDIR}/common/10-erspan0.network \
        ${D}${systemd_unitdir}/network
    install -m 0644 ${WORKDIR}/common/10-gretap0.network \
        ${D}${systemd_unitdir}/network

# Read-only
    install -d ${D}/${base_sbindir}
    echo '#!/bin/sh\nexec /sbin/init $@' > ${D}/${base_sbindir}/init.sh
    chmod 755 ${D}/${base_sbindir}/init.sh

# Tests
    install -d ${D}${sysconfdir}/modules-load.d
    install -m 0644 ${WORKDIR}/test/usb-cdc-acm.conf ${D}/${sysconfdir}/modules-load.d/
}

PACKAGES =+ " \
    ${PN}-common \
    ${PN}-host \
    ${PN}-security \
    ${PN}-ro \
    ${PN}-test \
    ${PN}-keymap \
"
SYSTEMD_PACKAGES += " \
    ${PN}-common \
    ${PN}-host \
"

SYSTEMD_SERVICE:${PN}-common = " \
    var-log.mount \
"

SYSTEMD_SERVICE:${PN}-host = " \
    hugetlb-gigantic-pages.service \
    rt-runtime-share.service \
"

REQUIRED_DISTRO_FEATURES = "systemd"

inherit allarch systemd features_check

FILES:${PN}-common = " \
    ${sysconfdir}/sysctl.d/99-sysctl-network.conf \
    ${systemd_unitdir}/system/var-log.mount \
    ${systemd_unitdir}/network/10-erspan0.network \
    ${systemd_unitdir}/network/10-gretap0.network \
"

FILES:${PN}-keymap = " \
    ${sysconfdir}/vconsole.conf \
"

FILES:${PN}-host = " \
    ${systemd_unitdir}/system/hugetlb-gigantic-pages.service \
    ${systemd_unitdir}/system/rt-runtime-share.service \
    ${sbindir}/hugetlb-reserve-pages.sh \
    ${sbindir}/enable-rt-runtime-share.sh \
"

FILES:${PN}-security = " \
    ${sbindir}/disable-local-login.sh \
    ${sysconfdir}/sysctl.d/90-sysctl-hardening.conf \
    ${sysconfdir}/profile.d/terminal_idle.sh \
"

FILES:${PN}-ro = "${base_sbindir}/init.sh"

FILES:${PN}-test = "${sysconfdir}/modules-load.d/usb-cdc-acm.conf"
