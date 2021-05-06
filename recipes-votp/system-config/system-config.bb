# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Votp System configuration"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"

SRC_URI = " \
    file://common/90-sysctl-hardening.conf \
    file://common/99-sysctl-network.conf \
    file://common/votp-loadkeys.service \
    file://host/openvswitch.conf \
    file://host/votp-config_ovs.service \
"

do_install () {
    install -d ${D}${systemd_unitdir}/system

# Common
    install -m 0644 ${WORKDIR}/common/votp-loadkeys.service \
        ${D}${systemd_unitdir}/system
    install -d ${D}${sysconfdir}/sysctl.d
    install -m 0644 ${WORKDIR}/common/90-sysctl-hardening.conf \
        ${D}${sysconfdir}/sysctl.d
    install -m 0644 ${WORKDIR}/common/99-sysctl-network.conf \
        ${D}${sysconfdir}/sysctl.d

# Host
    install -m 0644 ${WORKDIR}/host/votp-config_ovs.service \
        ${D}${systemd_unitdir}/system
    install -d ${D}${sysconfdir}/modules-load.d
    install -m 0644 ${WORKDIR}/host/openvswitch.conf \
        ${D}${sysconfdir}/modules-load.d
}

PACKAGES =+ " \
    ${PN}-common \
    ${PN}-host \
"

SYSTEMD_PACKAGES += " \
    ${PN}-common \
    ${PN}-host \
"

SYSTEMD_SERVICE_${PN}-common = " \
    votp-loadkeys.service \
"

SYSTEMD_SERVICE_${PN}-host = " \
    votp-config_ovs.service \
"

REQUIRED_DISTRO_FEATURES = "systemd"

inherit allarch systemd features_check

FILES_${PN}-common = " \
    ${sysconfdir}/sysctl.d/90-sysctl-hardening.conf \
    ${sysconfdir}/sysctl.d/99-sysctl-network.conf \
    ${systemd_unitdir}/system/votp-loadkeys.service \
"

FILES_${PN}-host = " \
    ${systemd_unitdir}/system/votp-config_ovs.service \
    ${sysconfdir}/modules-load.d/openvswitch.conf \
"
