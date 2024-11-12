# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Seapath System configuration cluster"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"
RDEPENDS:${PN} = "python3-setup-ovs openvswitch libvirt pacemaker"

# Add DEPENDS required for create the livemigration user
DEPENDS += "libvirt pacemaker"

SRC_URI = " \
    file://openvswitch.conf \
    file://seapath-config_ovs.service \
"

USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = "\
    --system \
    -G haclient,libvirt \
    -M livemigration \
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

inherit allarch systemd features_check useradd

FILES:${PN} = " \
    ${sysconfdir}/modules-load.d/openvswitch.conf \
    ${systemd_unitdir}/system/seapath-config_ovs.service \
"
