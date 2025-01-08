# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Seapath openvswitch System configuration"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RDEPENDS:${PN} = "python3-setup-ovs openvswitch"

SRC_URI = " \
    file://openvswitch.conf \
    file://seapath-config_ovs.service \
"

do_install () {

    install -d ${D}${sysconfdir}/modules-load.d
    install -m 0644 ${WORKDIR}/openvswitch.conf \
        ${D}${sysconfdir}/modules-load.d
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/seapath-config_ovs.service \
        ${D}${systemd_unitdir}/system
}

SYSTEMD_PACKAGES += "${PN}"

SYSTEMD_SERVICE:${PN} = " \
    seapath-config_ovs.service \
"

REQUIRED_DISTRO_FEATURES = "systemd"

inherit allarch systemd features_check

FILES:${PN} = " \
    ${sysconfdir}/modules-load.d/openvswitch.conf \
    ${systemd_unitdir}/system/seapath-config_ovs.service \
"
