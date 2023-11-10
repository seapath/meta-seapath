# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "SEAPATH update system configuration"
DESCRIPTION = "\
    Update system configuration for SEAPATH. Contains scripts to \
    switch bootloader, check if the system is running from the inactive bank \
    and udev rules to create symlinks to partitions."
SECTION = "base"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "\
    file://is_from_inactive_bank.sh \
    file://partition_symlinks.rules \
    file://switch_bootloader.sh \
    file://swupdate_check.sh \
    file://swupdate_check.service \
    file://swupdate_hawkbit.conf \
    file://swupdate_hawkbit.service \
    file://swupdate_hawkbit.sh \
    file://check-health.sh \
"

SRCREV = "1.2"
inherit allarch systemd

PACKAGES =+ "${PN}-hawkbit"

do_install () {
    install -d ${D}${datadir}/update
    install -d ${D}${sysconfdir}/udev/rules.d
    install -d ${D}${sysconfdir}/sysconfig
    install -d ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/is_from_inactive_bank.sh \
        ${D}${datadir}/update/is_from_inactive_bank.sh
    install -m 0644 ${WORKDIR}/partition_symlinks.rules \
        ${D}${sysconfdir}/udev/rules.d
    install -m 0755 ${WORKDIR}/switch_bootloader.sh \
        ${D}${datadir}/update/switch_bootloader.sh
    install -m 0755 ${WORKDIR}/check-health.sh \
        ${D}${datadir}/update/check-health.sh
    install -m 0755 ${WORKDIR}/swupdate_check.sh \
        ${D}${datadir}/update/swupdate_check.sh
    install -m 0644 ${WORKDIR}/swupdate_check.service \
        ${D}${systemd_unitdir}/system/swupdate_check.service

    # hawkbit
    install -m 0755 ${WORKDIR}/swupdate_hawkbit.sh \
        ${D}${datadir}/update/swupdate_hawkbit.sh
    install -m 0644 ${WORKDIR}/swupdate_hawkbit.conf \
        ${D}${sysconfdir}/sysconfig/swupdate_hawkbit.conf
    sed -i "s|@SEAPATH_HAWKBIT_SERVER_URL@|${SEAPATH_HAWKBIT_SERVER_URL}|" \
        ${D}${sysconfdir}/sysconfig/swupdate_hawkbit.conf
    install -m 0644 ${WORKDIR}/swupdate_hawkbit.service \
        ${D}${systemd_unitdir}/system/swupdate_hawkbit.service
}

FILES:${PN}:append = " \
    ${sysconfdir}/udev/rules.d/partition_symlinks.rules \
    ${datadir}/update/is_from_inactive_bank.sh \
    ${datadir}/update/switch_bootloader.sh \
    ${datadir}/update/check-health.sh \
    ${datadir}/update/swupdate_check.sh \
    ${systemd_unitdir}/system/swupdate_check.service \
"
FILES:${PN}-hawkbit:append = " \
    ${datadir}/update/swupdate_hawkbit.sh \
    ${sysconfdir}/sysconfig/swupdate_hawkbit.conf \
    ${systemd_unitdir}/system/swupdate_hawkbit.service \
"

RDEPENDS:${PN} = "bash dosfstools grub-efi-editenv swupdate udev"
RDEPENDS:${PN}-hawkbit = "bash ${PN}"

SYSTEMD_SERVICE:${PN} = "swupdate_check.service"
SYSTEMD_SERVICE:${PN}-hawkbit = "swupdate_hawkbit.service"
