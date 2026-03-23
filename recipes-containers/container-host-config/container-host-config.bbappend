# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Install a containers.conf file to change the default network driver.
# Only for scarthgap we need to remove it in the next LTS.
SRC_URI:append = " \
    file://containers.conf \
    file://setup-podman-dirs.sh \
    file://podman-user-dirs.service \
"

inherit systemd security/users

do_install:append() {
    install -m 0644 ${UNPACKDIR}/containers.conf ${D}${sysconfdir}/containers/containers.conf
    install -d ${D}${sbindir}
    install -m 0755 ${UNPACKDIR}/setup-podman-dirs.sh ${D}${sbindir}/setup-podman-dirs.sh
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/podman-user-dirs.service ${D}${systemd_system_unitdir}/podman-user-dirs.service
    install -d ${D}/etc/sysconfig
    echo "USER_CONTAINER_LIST=\"${USER_CONTAINER_LIST}\"" > ${D}/etc/sysconfig/setup-podman-dirs
}

SYSTEMD_SERVICE:${PN} = "podman-user-dirs.service"
