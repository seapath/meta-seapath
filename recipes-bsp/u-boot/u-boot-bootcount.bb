
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Systemd service to reset U-Boot bootcount on boot"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-imx:"

SRC_URI = " \
    file://u-boot-bootcount.service \
    file://fw_env.config \
"

inherit systemd

RDEPENDS:${PN} = "libubootenv-bin"

do_install() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/u-boot-bootcount.service ${D}${systemd_unitdir}/system/
}

SYSTEMD_SERVICE:${PN} = " u-boot-bootcount.service"

FILES:${PN} += "${sysconfdir}/fw_env.config"
