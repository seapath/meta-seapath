# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Install a containers.conf file to change the default network driver.
# Only for scarthgap we need to remove it in the next LTS.
SRC_URI += "file://containers.conf"

do_install:append() {
    install -m 0644 ${WORKDIR}/containers.conf ${D}${sysconfdir}/containers/containers.conf
}
