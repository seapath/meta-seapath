# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Votp System configuration"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"
RDEPENDS:${PN}-efi = "bash"
RDEPENDS:${PN}-security = "bash"
RDEPENDS:${PN}-cluster= "python3-setup-ovs openvswitch"

SRC_URI = " \
    file://common/90-sysctl-hardening.conf \
    file://common/99-sysctl-network.conf \
    file://common/terminal_idle.sh \
    file://common/var-log.mount \
    file://cluster/openvswitch.conf \
    file://cluster/votp-config_ovs.service \
    file://host/hugetlb-gigantic-pages.service \
    file://host/hugetlb-reserve-pages.sh \
    file://efi/swupdate_hawkbit.conf \
    file://efi/swupdate_hawkbit.service \
    file://efi/swupdate_hawkbit.sh \
    file://efi/check-health.sh \
    file://security/disable-local-login.sh \
"

do_install () {
    install -d ${D}/${sbindir}
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}${sysconfdir}/sysconfig

# Common
    if [ -z "${SEAPATH_KEYMAP}" ] ; then
         SEAPATH_KEYMAP=us
    fi
    echo "KEYMAP=\"${SEAPATH_KEYMAP}\"" > ${D}${sysconfdir}/vconsole.conf
    install -d ${D}${sysconfdir}/sysctl.d
    if ! ${@bb.utils.contains('DISTRO_FEATURES','seapath-security','true','false', d)}; then
        install -m 0644 ${WORKDIR}/common/90-sysctl-hardening.conf \
            ${D}${sysconfdir}/sysctl.d
    fi
    install -m 0644 ${WORKDIR}/common/99-sysctl-network.conf \
        ${D}${sysconfdir}/sysctl.d
    install -d ${D}${sysconfdir}/profile.d
    install -m 0644 ${WORKDIR}/common/terminal_idle.sh \
        ${D}${sysconfdir}/profile.d
    install -m 0644 ${WORKDIR}/common/var-log.mount \
        ${D}${systemd_unitdir}/system

    if ! ${@bb.utils.contains('PACKAGECONFIG','seapath-readonly','true','false', d)}; then
        install -d ${D}/${base_sbindir}
        echo '#!/bin/sh\nexec /sbin/init $@' > ${D}/${base_sbindir}/init.sh
        chmod 755 ${D}/${base_sbindir}/init.sh
    fi

# Cluster
    install -d ${D}${sysconfdir}/modules-load.d
    install -m 0644 ${WORKDIR}/cluster/openvswitch.conf \
        ${D}${sysconfdir}/modules-load.d
    install -m 0644 ${WORKDIR}/cluster/votp-config_ovs.service \
        ${D}${systemd_unitdir}/system

# Host
    install -m 0644 ${WORKDIR}/host/hugetlb-gigantic-pages.service \
        ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/host/hugetlb-reserve-pages.sh \
        ${D}/${sbindir}

# EFI
    install -m 0644 ${WORKDIR}/efi/swupdate_hawkbit.conf \
        ${D}${sysconfdir}/sysconfig
    install -m 0755 ${WORKDIR}/efi/swupdate_hawkbit.sh \
        ${D}/${sbindir}
    install -m 0644 ${WORKDIR}/efi/swupdate_hawkbit.service \
        ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/efi/check-health.sh \
        ${D}/${sbindir}/check-health

# Security
    install -m 0755 ${WORKDIR}/security/disable-local-login.sh \
        ${D}/${sbindir}
}

PACKAGES =+ " \
    ${PN}-common \
    ${PN}-host \
    ${PN}-efi \
    ${PN}-security \
    ${PN}-cluster \
"
SYSTEMD_PACKAGES += " \
    ${PN}-common \
    ${PN}-host \
    ${PN}-efi \
    ${PN}-cluster \
"

SYSTEMD_SERVICE:${PN}-common = " \
    var-log.mount \
"

SYSTEMD_SERVICE:${PN}-cluster = " \
    votp-config_ovs.service \
"

SYSTEMD_SERVICE:${PN}-host = " \
    hugetlb-gigantic-pages.service \
"

SYSTEMD_SERVICE:${PN}-efi = " \
    swupdate_hawkbit.service \
"

REQUIRED_DISTRO_FEATURES = "systemd"

inherit allarch systemd features_check

FILES:${PN}-common = " \
    "${@bb.utils.contains('DISTRO_FEATURES','seapath-security',"${sysconfdir}/sysctl.d/90-sysctl-hardening.conf","",d)}" \
    ${sysconfdir}/sysctl.d/99-sysctl-network.conf \
    ${sysconfdir}/profile.d/terminal_idle.sh \
    ${systemd_unitdir}/system/var-log.mount \
    ${sysconfdir}/vconsole.conf \
"

FILES:${PN}-cluster = " \
    ${sysconfdir}/modules-load.d/openvswitch.conf \
    ${systemd_unitdir}/system/votp-config_ovs.service \
"

FILES:${PN}-host = " \
    ${systemd_unitdir}/system/hugetlb-gigantic-pages.service \
    ${sbindir}/hugetlb-reserve-pages.sh \
"

FILES:${PN}-efi = " \
    ${sysconfdir}/sysconfig/swupdate_hawkbit.conf \
    ${sbindir}/swupdate_hawkbit.sh \
    ${system_unitdir}/system/swupdate_hawkbit.service \
    ${sbindir}/check-health \
"

FILES:${PN}-security = " \
    ${sbindir}/disable-local-login.sh \
"

FILES:${PN}-common:append = "${@bb.utils.contains('DISTRO_FEATURES','seapath-readonly', "", " ${base_sbindir}/init.sh", d)}"
